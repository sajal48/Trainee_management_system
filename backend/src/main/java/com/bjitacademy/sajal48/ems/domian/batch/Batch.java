package com.bjitacademy.sajal48.ems.domian.batch;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class Batch implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "sequence_generator")
    private Long id;
    private String description;
    private String batchName;
    private String startDate;
    private String endDate;
    private Boolean status;
    @Builder.Default
    @OneToMany(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinTable(
            name = "batches_trainees",
            joinColumns = @JoinColumn(name = "batch_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<UserDetails> trainees = new HashSet<>();
}