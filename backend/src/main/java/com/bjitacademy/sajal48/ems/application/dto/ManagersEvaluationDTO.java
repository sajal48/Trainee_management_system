package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.evaluation.ManagerEvaluation;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
@Data
public class ManagersEvaluationDTO {
    @Valid
    @NotNull(message = "traineeId cannot be empty")
    Long traineeId;
    @NotNull(message = "batchId cannot be empty")
    Long batchId;
    @NotNull(message = "obtainedMark cannot be empty")
    @Min(value = 0, message = "obtainedMark must be greater than or equal to 0")
    @Max(value = 85, message = "obtainedMark must be less than or equal to 85")
    Double obtainedMark;
    Double bjitTools;
    Double officeRules;
    Double sincerity;
    Double quality;
    Double attendance;
    Double communicationSkill;
    Double englishLanguageSkill;
    public static ManagerEvaluation toEntity(ManagersEvaluationDTO dto) {
        return ManagerEvaluation.builder()
                .traineeId(dto.traineeId)
                .batchId(dto.batchId)
                .attendance(dto.attendance)
                .bjitTools(dto.bjitTools)
                .officeRules(dto.officeRules)
                .sincerity(dto.sincerity)
                .quality(dto.quality)
                .communicationSkill(dto.communicationSkill)
                .englishLanguageSkill(dto.englishLanguageSkill)
                .obtainedMark(dto.obtainedMark)
                .build();
    }
}
