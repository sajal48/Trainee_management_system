package com.bjitacademy.sajal48.ems.domian.evaluation;
import java.util.List;
import java.util.Optional;
public interface AptitudeAndHrEvaluationRepository {
    AptitudeAndHrEvaluation save(AptitudeAndHrEvaluation aptitudeAndHrEvaluation);
    List<AptitudeAndHrEvaluation> findAllByBatchId(Long batchId);
    List<AptitudeAndHrEvaluation> findAllByTraineeId(Long traineeId);
    Optional<AptitudeAndHrEvaluation> findById(Long id);
    List<AptitudeAndHrEvaluation> findAll();
}