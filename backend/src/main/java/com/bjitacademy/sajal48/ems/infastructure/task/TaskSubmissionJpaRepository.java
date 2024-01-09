package com.bjitacademy.sajal48.ems.infastructure.task;
import com.bjitacademy.sajal48.ems.domian.task.TaskSubMissionRepository;
import com.bjitacademy.sajal48.ems.domian.task.TaskSubmission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface TaskSubmissionJpaRepository extends TaskSubMissionRepository, JpaRepository<TaskSubmission, Long> {
}