package com.bjitacademy.sajal48.ems.infastructure.evaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.TaskEvaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.TaskEvaluationRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface TaskEvaluationJpaRepository extends TaskEvaluationRepository, JpaRepository<TaskEvaluation, Long> {
}
