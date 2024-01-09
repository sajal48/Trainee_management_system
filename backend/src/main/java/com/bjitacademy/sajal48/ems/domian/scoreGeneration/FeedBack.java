package com.bjitacademy.sajal48.ems.domian.scoreGeneration;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class FeedBack {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private String trainerId;
    private String trainerName;
    @Length(max = 5000)
    private String message;
}
