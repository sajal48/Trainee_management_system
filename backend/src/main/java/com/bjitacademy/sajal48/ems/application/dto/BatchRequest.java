package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.batch.Batch;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

import java.util.List;
@Data
public class BatchRequest {
    @Valid
    @NotNull(message = "Please provide a name")
    String batchName;
    String description;
    @NotEmpty(message = "Please provide a StartDate")
    @Pattern(regexp = "\\d{4}/\\d{2}/\\d{2}", message = "Invalid date format. Please use the format: YYYY/MM/DD")
    String startDate;
    @NotEmpty(message = "Please provide a EndDate")
    @Pattern(regexp = "\\d{4}/\\d{2}/\\d{2}", message = "Invalid date format. Please use the format: YYYY/MM/DD")
    String endDate;
    boolean status;
    List<Long> userIds;
    public static Batch getBatchFromBatchRequest(BatchRequest batchRequest) {
        try {
            return Batch.builder()
                    .batchName(batchRequest.batchName)
                    .startDate(batchRequest.startDate)
                    .endDate(batchRequest.endDate)
                    .status(batchRequest.status)
                    .description(batchRequest.description)
                    .build();
        } catch (Exception e) {
            throw new RuntimeException("Date parsing error");
        }
    }
}