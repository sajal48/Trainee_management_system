package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.domian.file.FileInfo;
import com.bjitacademy.sajal48.ems.domian.file.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
@Controller
@RequestMapping("api/v1/file")
@RequiredArgsConstructor
public class FileController {
    private final FileService fileService;
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> saveFile(@RequestPart MultipartFile file) throws IOException {
        FileInfo fileInfo = fileService.uploadFile(file);
        return new ResponseEntity<>(fileInfo, HttpStatus.CREATED);
    }
    @GetMapping("/{id}")
    public ResponseEntity<?> downloadFileById(@PathVariable Long id) {
        byte[] fileContent = fileService.getFile(id);
        FileInfo fileInfo = fileService.getFileInfo(id);
        String filename = fileInfo.getFileName();
        ByteArrayResource resource = new ByteArrayResource(fileContent);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .contentLength(fileContent.length)
                .body(resource);
    }
}
