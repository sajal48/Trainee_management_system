package com.bjitacademy.sajal48.ems.domian.task;
import java.util.List;
import java.util.Optional;
public interface TaskSubMissionRepository {
    TaskSubmission save(TaskSubmission taskSubmission);
    Optional<TaskSubmission> findById(Long id);
    List<TaskSubmission> findAllByTaskId(Long taskId);
}
