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
public class ManagerEvaluation {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private Long traineeId;
    private Long batchId;
    private Double totalMark;
    private Double obtainedMark;
    private Double bjitTools;
    private Double officeRules;
    private Double sincerity;
    private Double quality;
    private Double attendance;
    private Double communicationSkill;
    private Double englishLanguageSkill;
}
