package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.evaluation.Weightage;
import lombok.Data;
@Data
public class WeightageDto {
    Double dailyTaskEvaluationWeightage;
    Double miniProjectEvaluationWeightage;
    Double midProjectEvaluationWeightage;
    Double finalProjectEvaluationWeightage;
    Double domainWeightage;
    Double managerEvaluationWeightage;
    Double trainingWeightage;
    Double hrInterviewEvaluationWeightage;
    public static Weightage weightageFromWeightageDto(WeightageDto weightageDto) {
        return Weightage.builder()
                .domainWeightage(weightageDto.domainWeightage)
                .dailyTaskEvaluationWeightage(weightageDto.dailyTaskEvaluationWeightage)
                .miniProjectEvaluationWeightage(weightageDto.miniProjectEvaluationWeightage)
                .midProjectEvaluationWeightage(weightageDto.midProjectEvaluationWeightage)
                .finalProjectEvaluationWeightage(weightageDto.finalProjectEvaluationWeightage)
                .managerEvaluationWeightage(weightageDto.managerEvaluationWeightage)
                .trainingWeightage(weightageDto.trainingWeightage)
                .hrInterviewEvaluationWeightage(weightageDto.hrInterviewEvaluationWeightage)
                .build();
    }
}
