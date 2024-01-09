package com.bjitacademy.sajal48.ems.domian.file;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.UUID;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class FileService {
    private final FileInfoRepository fileInfoRepository;
    public FileService(FileInfoRepository fileInfoRepository) {
        this.fileInfoRepository = fileInfoRepository;
    }
    /**
     * Uploads a file and returns the ID of the stored file.
     *
     * @param file The file to be uploaded
     * @return The fileInfo of the stored file
     */
    @Transactional
    public FileInfo uploadFile(MultipartFile file) {
        try {
            String currentDirectoryPath = System.getProperty("user.dir") + "\\files\\";
            File directory = new File(currentDirectoryPath);
            if (!directory.exists()) {
                Files.createDirectory(Path.of(currentDirectoryPath));
            }
            LocalDateTime currentTime = LocalDateTime.now();
            String timestamp = currentTime.format(DateTimeFormatter.ofPattern(DATE_FORMAT_FILES));
            String randomString = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
            String fileName = timestamp + "_" + randomString + "_" + file.getOriginalFilename();
            String filePath = currentDirectoryPath + fileName;
            FileInfo fileinfo = fileInfoRepository.save(FileInfo.builder()
                    .fileUrl(filePath)
                    .fileName(fileName)
                    .fileType(file.getContentType())
                    .build());
            file.transferTo(new File(filePath));
            return fileinfo;
        } catch (Exception e) {
            throw new DatabaseException(FILE_UPLOAD_FAILURE);
        }
    }
    /**
     * Retrieves the file data with the given file ID.
     *
     * @param fileId The ID of the file to retrieve
     * @return The byte array representing the file content
     */
    @Transactional(readOnly = true)
    public byte[] getFile(Long fileId) {
        try {
            Optional<FileInfo> fileData = fileInfoRepository.findById(fileId);
            String filePath = fileData.get().getFileUrl();
            byte[] file = Files.readAllBytes(new File(filePath).toPath());
            return file;
        } catch (Exception e) {
            throw new DatabaseException(FILE_DOWNLOAD_FAILURE);
        }
    }
    /**
     * returns the File from the stored file by id.
     *
     * @param id of The file to be downloaded
     * @return The FileInfo
     */
    @Transactional(readOnly = true)
    public FileInfo getFileInfo(Long id) {
        Optional<FileInfo> fileData = fileInfoRepository.findById(id);
        return fileData.get();
    }
    /**
     * Checks the existence of a file with the given ID in the file info repository.
     *
     * @param id The ID of the file to check.
     * @throws NoSuchElementException If no file info is found with the given ID.
     */
    @Transactional(readOnly = true)
    public void checkFile(long id) {
        var file = fileInfoRepository.findById(id).orElseThrow();
    }
}
