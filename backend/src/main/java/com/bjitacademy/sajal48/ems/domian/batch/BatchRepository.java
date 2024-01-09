package com.bjitacademy.sajal48.ems.domian.batch;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
public interface BatchRepository {
    Batch save(Batch batch);
    Optional<Batch> findBatchById(Long id);
    @Query(value = "SELECT batch_id FROM batches_trainees WHERE user_id = :user_id", nativeQuery = true)
    long findBatchByUserId(@Param("user_id") long userId);
    @Query(value = "SELECT COUNT(*) FROM batches_trainees WHERE user_id = :user_id", nativeQuery = true)
    Long countByUserId(@Param("user_id") long userId);
    List<Batch> findAll();
    void delete(Batch batch);
}
