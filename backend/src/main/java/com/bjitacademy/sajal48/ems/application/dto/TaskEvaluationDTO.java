package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.evaluation.TaskEvaluation;
import lombok.Data;
@Data
public class TaskEvaluationDTO {
    Long batchId;
    Long traineeId;
    Long evaluatorId;
    Long taskId;
    Double obtainedMark;
    Double requirementUnderstanding;
    Double expectedOutput;
    Double codeQuality;
    Double demonstrationOrPresentation;
    Double liveCodingOrCodeUnderstanding;
    String taskType;
    public static TaskEvaluation fromDto(TaskEvaluationDTO dto) {
        return TaskEvaluation.builder()
                .batchId(dto.batchId)
                .traineeId(dto.traineeId)
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