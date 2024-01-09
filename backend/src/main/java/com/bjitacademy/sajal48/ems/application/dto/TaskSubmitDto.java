package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.task.TaskSubmission;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;
@Data
public class TaskSubmitDto {
    @Valid
    @NotNull(message = "taskId cannot be empty")
    Long taskId;
    @NotNull(message = "traineeId cannot be empty")
    Long traineeId;
    String description;
    MultipartFile file;
    public static TaskSubmission toTaskSubmission(TaskSubmitDto dto, Long fileId) {
        return TaskSubmission.builder()
                .taskId(dto.taskId)
                .traineeId(dto.traineeId)
                .description(dto.description)
                .fileId(fileId)
                .build();
    }
}
