package com.bjitacademy.sajal48.ems.domian.credential;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@SequenceGenerator(name = "uid_generator", sequenceName = "uid_sequence", allocationSize = 1, initialValue = 1)
public class UserCredential {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "uid_generator")
    private Long userId;
    private String email;
    private String password;
    @ManyToOne(fetch = FetchType.EAGER)
    private UserRole role;
}
