package com.bjitacademy.sajal48.ems.domian.task;
import java.util.List;
import java.util.Optional;
public interface TaskRepository {
    Task save(Task task);
    Optional<Task> findById(Long id);
    List<Task> findAllByBatchIdAndTaskType(Long batchId, String taskType);
    List<Task> findAllByBatchId(Long batchId);
    List<Task> findAll();
}
