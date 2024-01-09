package com.bjitacademy.sajal48.ems.domian.scoreGeneration;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
public interface FinalScoreRepository {
    FinalScore save(FinalScore finalScore);
    List<FinalScore> findAllByBatchId(Long batchId);
    Optional<FinalScore> findById(Long id);
    <S extends FinalScore> List<S> saveAll(Iterable<S> entities);
    @Modifying
    @Transactional
    @Query("DELETE FROM FinalScore e WHERE e.batchId = :batchId")
    void removeWhereBatchId(Long batchId);
    List<FinalScore> findAll();
}