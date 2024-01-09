package com.bjitacademy.sajal48.ems.infastructure.task;
import com.bjitacademy.sajal48.ems.domian.task.Task;
import com.bjitacademy.sajal48.ems.domian.task.TaskRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface TaskJpaRepository extends TaskRepository, JpaRepository<Task, Long> {
}
