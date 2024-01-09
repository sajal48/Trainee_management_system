package com.bjitacademy.sajal48.ems.domian.scoreGeneration;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class
FinalScore {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private Long traineeId;
    private Long batchId;
    private Double totalScore;
    private Double dailyTask;
    private Double miniProjectScore;
    private Double midProjectScore;
    private Double finalProjectScore;
    private Double managersEvaluationScore;
    private Double hrEvaluationScore;
    private Double domainScore;
    private Double trainingTotalScore;
    @Builder.Default
    @OneToMany
    private Set<FeedBack> feedBacks = new HashSet<>();
    @Override
    public String toString() {
        return "FinalScore{" +
                "id=" + id +
                ", traineeId=" + traineeId +
                ", batchId=" + batchId +
                ", totalScore=" + totalScore +
                ", dailyTask=" + dailyTask +
                ", miniProjectScore=" + miniProjectScore +
                ", midProjectScore=" + midProjectScore +
                ", finalProjectScore=" + finalProjectScore +
                ", managersEvaluationScore=" + managersEvaluationScore +
                ", hrEvaluationScore=" + hrEvaluationScore +
                ", domainScore=" + domainScore +
                ", trainingTotalScore=" + trainingTotalScore +
                ", feedBacks=" + feedBacks +
                '}';
    }
}
