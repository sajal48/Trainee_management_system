package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.evaluation.TaskEvaluation;
import jakarta.validation.Valid;
import lombok.Data;
@Data
public class TaskEvaluationUpdateDTO {
    @Valid
    Long evaluatorId;
    Long taskId;
    Double obtainedMark;
    Double requirementUnderstanding;
    Double expectedOutput;
    Double codeQuality;
    Double demonstrationOrPresentation;
    Double liveCodingOrCodeUnderstanding;
    String taskType;
    public static TaskEvaluation fromDto(TaskEvaluationUpdateDTO dto) {
        return TaskEvaluation.builder()
                .evaluatorId(dto.evaluatorId)
                .taskId(dto.taskId)
                .obtainedMark(dto.obtainedMark)
                .requirementUnderstanding(dto.requirementUnderstanding)
                .expectedOutput(dto.expectedOutput)
                .codeQuality(dto.codeQuality)
                .demonstrationOrPresentation(dto.demonstrationOrPresentation)
                .liveCodingOrCodeUnderstanding(dto.liveCodingOrCodeUnderstanding)
                .build();
    }
}