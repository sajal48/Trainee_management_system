package com.bjitacademy.sajal48.ems.domian.file;
import java.util.Optional;
public interface FileInfoRepository {
    FileInfo save(FileInfo fileInfo);
    Optional<FileInfo> findById(Long id);
}
