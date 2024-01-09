package com.bjitacademy.sajal48.ems.infastructure.finalScore;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FeedBack;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FeedBackRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface FeedBackJpaRepository extends FeedBackRepository, JpaRepository<FeedBack, Long> {
}