package com.bjitacademy.sajal48.ems.domian.evaluation;
import java.util.List;
import java.util.Optional;
public interface ManagerEvaluationRepository {
    ManagerEvaluation save(ManagerEvaluation managerEvaluation);
    List<ManagerEvaluation> findAllByBatchId(Long batchId);
    List<ManagerEvaluation> findAllByTraineeId(Long batchId);
    Optional<ManagerEvaluation> findById(Long id);
    List<ManagerEvaluation> findAll();
}