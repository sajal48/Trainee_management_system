package com.bjitacademy.sajal48.ems.domian.evaluation;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AptitudeAndHrEvaluation {
    @Valid
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    @NotNull(message = "traineeId cannot be empty")
    private Long traineeId;
    private Long batchId;
    private Double hrInterviewMark;
    private Double totalMark;
    @NotNull(message = "obtainedMark cannot be empty")
    @Min(value = 0, message = "obtainedMark must be greater than or equal to 0")
    @Max(value = 100, message = "obtainedMark must be less than or equal to 100")
    private Double obtainedMark;
}
