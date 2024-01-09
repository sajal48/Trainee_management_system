package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.evaluation.FinalProjectEvaluation;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
@Data
public class FinalProjectEvaluationDTO {
    @Valid
    Long batchId;
    Double srs;
    Double wbs;
    Double designDocument;
    Double ppt;
    Long traineeId;
    Long evaluatorId;
    String evaluatedOn;
    Double totalMark;
    @NotNull(message = "obtainedMark cannot be empty")
    @Min(value = 0, message = "obtainedMark must be greater than or equal to 0")
    @Max(value = 100, message = "obtainedMark must be less than or equal to 100")
    Double obtainedMark;
    Double requirementUnderstanding;
    Double expectedOutput;
    Double codeQuality;
    Double demonstrationOrPresentation;
    Double liveCodingOrCodeUnderstanding;
    public static FinalProjectEvaluation toEntity(FinalProjectEvaluationDTO dto) {
        return FinalProjectEvaluation.builder()
                .batchId(dto.batchId)
                .traineeId(dto.traineeId)
                .evaluatorId(dto.evaluatorId)
                .srs(dto.srs)
                .wbs(dto.wbs)
                .designDocument(dto.designDocument)
                .ppt(dto.ppt)
                .obtainedMark(dto.obtainedMark)
                .requirementUnderstanding(dto.requirementUnderstanding)
                .expectedOutput(dto.expectedOutput)
                .codeQuality(dto.codeQuality)
                .demonstrationOrPresentation(dto.demonstrationOrPresentation)
                .liveCodingOrCodeUnderstanding(dto.liveCodingOrCodeUnderstanding)
                .build();
    }
}
