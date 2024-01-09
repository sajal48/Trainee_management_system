package com.bjitacademy.sajal48.ems.domian.evaluation;
import java.util.List;
import java.util.Optional;
public interface TaskEvaluationRepository {
    TaskEvaluation save(TaskEvaluation taskEvaluation);
    List<TaskEvaluation> findAllByBatchIdAndEvaluationTypeAndEvaluatedOn(Long batchId, String taskType, String date);
    List<TaskEvaluation> findAllByBatchIdAndEvaluationType(Long batchId, String taskType);
    Optional<TaskEvaluation> findById(Long id);
    List<TaskEvaluation> findAllByTraineeIdAndEvaluationType(Long traineeId, String taskType);
}