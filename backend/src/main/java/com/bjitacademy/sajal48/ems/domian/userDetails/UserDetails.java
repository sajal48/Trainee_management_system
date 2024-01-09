package com.bjitacademy.sajal48.ems.domian.userDetails;
import jakarta.persistence.Entity;
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
public class UserDetails implements Serializable {
    @Id
    private Long userId;
    private String role;
    private String email;
    private String FullName;
    private String contactNo;
    private String dob;
    private String educationalInstitute;
    private String degreeName;
    private String passingYear;
    private String cgpa;
    private String designation;
    private String expertise;
    private String joiningDate;
    private String presentAddress;
    private Long profilePictureId;
}
