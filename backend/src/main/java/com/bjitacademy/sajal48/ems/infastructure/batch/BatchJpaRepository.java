package com.bjitacademy.sajal48.ems.infastructure.batch;
import com.bjitacademy.sajal48.ems.domian.batch.Batch;
import com.bjitacademy.sajal48.ems.domian.batch.BatchRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface BatchJpaRepository extends BatchRepository, JpaRepository<Batch, Long> {
}
