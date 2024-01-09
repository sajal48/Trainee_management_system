package com.bjitacademy.sajal48.ems.infastructure.weightage;
import com.bjitacademy.sajal48.ems.domian.evaluation.Weightage;
import com.bjitacademy.sajal48.ems.domian.evaluation.WeightageRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface WeightageJpaRepository extends WeightageRepository, JpaRepository<Weightage, Long> {
}