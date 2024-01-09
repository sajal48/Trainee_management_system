package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;
@Data
public class UserRequest {
    @Valid
    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Invalid email format")
    String email;
    @NotEmpty(message = "Password cannot be empty")
    @Size(min = 6, message = "Password must be at least 6 characters long")
    String password;
    String FullName;
    String contactNo;
    String dob;
    String educationalInstitute;
    String degreeName;
    String passingYear;
    String cgpa;
    String designation;
    String expertise;
    String joiningDate;
    String presentAddress;
    public static UserDetails toUserInfo(UserRequest userRequest) {
        UserDetails userInfo = new UserDetails();
        userInfo.setEmail(userRequest.getEmail());
        userInfo.setFullName(userRequest.getFullName());
        userInfo.setContactNo(userRequest.getContactNo());
        userInfo.setDob(userRequest.getDob());
        userInfo.setEducationalInstitute(userRequest.getEducationalInstitute());
        userInfo.setDegreeName(userRequest.getDegreeName());
        userInfo.setPassingYear(userRequest.getPassingYear());
        userInfo.setCgpa(userRequest.getCgpa());
        userInfo.setDesignation(userRequest.getDesignation());
        userInfo.setExpertise(userRequest.getExpertise());
        userInfo.setJoiningDate(userRequest.getJoiningDate());
        userInfo.setPresentAddress(userRequest.getPresentAddress());
        return userInfo;
    }
}
