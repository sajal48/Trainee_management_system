package com.bjitacademy.sajal48.ems.domian.evaluation;
import java.util.List;
public interface WeightageRepository {
    Weightage save(Weightage weightage);
    List<Weightage> findAll();
}
