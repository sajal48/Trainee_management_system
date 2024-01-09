package com.bjitacademy.sajal48.ems.infastructure.finalScore;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FinalScore;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FinalScoreRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface FinalScoreJpaRepository extends FinalScoreRepository, JpaRepository<FinalScore, Long> {
}