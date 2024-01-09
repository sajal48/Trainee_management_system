package com.bjitacademy.sajal48.ems.domian.evaluation;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Weightage implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private Double dailyTaskEvaluationWeightage;
    private Double miniProjectEvaluationWeightage;
    private Double midProjectEvaluationWeightage;
    private Double finalProjectEvaluationWeightage;
    private Double domainWeightage;
    private Double managerEvaluationWeightage;
    private Double trainingWeightage;
    private Double hrInterviewEvaluationWeightage;
}