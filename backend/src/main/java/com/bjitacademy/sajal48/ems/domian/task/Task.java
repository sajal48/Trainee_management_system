package com.bjitacademy.sajal48.ems.domian.task;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Task implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private Long assignedBy;
    private Long batchId;
    private String title;
    private String description;
    private String taskType;
    private Long fileId;
    private String createdAt;
    private String submissionDate;
}
