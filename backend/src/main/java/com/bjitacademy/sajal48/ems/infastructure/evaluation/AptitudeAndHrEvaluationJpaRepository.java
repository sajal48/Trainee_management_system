package com.bjitacademy.sajal48.ems.infastructure.evaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.AptitudeAndHrEvaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.AptitudeAndHrEvaluationRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface AptitudeAndHrEvaluationJpaRepository extends AptitudeAndHrEvaluationRepository, JpaRepository<AptitudeAndHrEvaluation, Long> {
}