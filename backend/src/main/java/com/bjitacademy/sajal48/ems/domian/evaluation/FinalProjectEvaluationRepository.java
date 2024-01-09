package com.bjitacademy.sajal48.ems.domian.evaluation;
import java.util.List;
import java.util.Optional;
public interface FinalProjectEvaluationRepository {
    FinalProjectEvaluation save(FinalProjectEvaluation finalProjectEvaluation);
    List<FinalProjectEvaluation> findAllByBatchId(Long batchId);
    List<FinalProjectEvaluation> findAllByTraineeId(Long traineeId);
    Optional<FinalProjectEvaluation> findById(Long id);
    List<FinalProjectEvaluation> findAll();
}