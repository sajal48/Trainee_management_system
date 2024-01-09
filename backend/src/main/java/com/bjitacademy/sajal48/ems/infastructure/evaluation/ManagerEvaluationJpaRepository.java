package com.bjitacademy.sajal48.ems.infastructure.evaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.ManagerEvaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.ManagerEvaluationRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface ManagerEvaluationJpaRepository extends ManagerEvaluationRepository, JpaRepository<ManagerEvaluation, Long> {
}