package com.bjitacademy.sajal48.ems.domian.scoreGeneration;
import java.util.Optional;
public interface FeedBackRepository {
    FeedBack save(FeedBack feedBack);
    Optional<FeedBack> findById(Long id);
}