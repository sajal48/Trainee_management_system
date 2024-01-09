package com.bjitacademy.sajal48.ems.domian.evaluation;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FinalProjectEvaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private Long batchId;
    private Double srs;
    private Double wbs;
    private Double designDocument;
    private Double ppt;
    private Long traineeId;
    private Long evaluatorId;
    private String evaluatedOn;
    private Double totalMark;
    private Double obtainedMark;
    private Double requirementUnderstanding;
    private Double expectedOutput;
    private Double codeQuality;
    private Double demonstrationOrPresentation;
    private Double liveCodingOrCodeUnderstanding;
}
