package com.bjitacademy.sajal48.ems.infastructure.fileinfo;
import com.bjitacademy.sajal48.ems.domian.file.FileInfo;
import com.bjitacademy.sajal48.ems.domian.file.FileInfoRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface FileInfoJpaInfoRepository extends FileInfoRepository, JpaRepository<FileInfo, Long> {
}
