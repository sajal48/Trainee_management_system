package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.task.Task;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;
@Data
public class TaskDto {
    @Valid
    @NotNull(message = "assignedBy cannot be empty")
    Long assignedBy;
    @NotNull(message = "batchId cannot be empty")
    Long batchId;
    String title;
    String description;
    @NotEmpty(message = "taskType cannot be empty")
    String taskType;
    @NotEmpty(message = "Please provide a StartDate")
    @Pattern(regexp = "\\d{4}/\\d{2}/\\d{2}", message = "Invalid date format. Please use the format: YYYY/MM/DD")
    String submissionDate;
    MultipartFile file;
    public static Task toTask(TaskDto dto, Long fileId) {
        return Task.builder()
                .assignedBy(dto.assignedBy)
                .batchId(dto.batchId)
                .taskType(dto.taskType)
                .title(dto.title)
                .description(dto.description)
                .submissionDate(dto.submissionDate)
                .fileId(fileId)
                .build();
    }
}
