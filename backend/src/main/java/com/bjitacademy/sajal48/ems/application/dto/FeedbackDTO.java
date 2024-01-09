package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FeedBack;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
@Data
public class FeedbackDTO {
    @Valid
    @NotNull(message = "trainerId cannot be empty")
    String trainerId;
    @NotNull(message = "trainerName cannot be empty")
    String trainerName;
    String message;
    public static FeedBack toEntity(FeedbackDTO dto) {
        return FeedBack.builder()
                .trainerId(dto.trainerId)
                .trainerName(dto.trainerName)
                .message(dto.message)
                .build();
    }
}
