package com.bjitacademy.sajal48.ems.infastructure.evaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.FinalProjectEvaluation;
import com.bjitacademy.sajal48.ems.domian.evaluation.FinalProjectEvaluationRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface FinalProjectEvaluationJpaRepository extends FinalProjectEvaluationRepository, JpaRepository<FinalProjectEvaluation, Long> {
}