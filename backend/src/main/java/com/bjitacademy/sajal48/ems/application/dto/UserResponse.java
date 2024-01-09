package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;
@Builder
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class UserResponse {
    Long userId;
    String role;
    String email;
    String fullName;
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
    Long profilePictureId;
    public static UserResponse UserResponseFromUserInfo(UserDetails userInfo) {
        UserResponse userResponse = UserResponse.builder()
                .userId(userInfo.getUserId())
                .email(userInfo.getEmail())
                .role(userInfo.getRole())
                .fullName(userInfo.getFullName())
                .contactNo(userInfo.getContactNo())
                .dob(userInfo.getDob())
                .joiningDate(userInfo.getJoiningDate())
                .presentAddress(userInfo.getPresentAddress())
                .profilePictureId(userInfo.getProfilePictureId())
                .build();
        if (userInfo.getRole().equals("TRAINER")) {
            userResponse.setEducationalInstitute(userInfo.getEducationalInstitute());
            userResponse.setDegreeName(userInfo.getDegreeName());
            userResponse.setPassingYear(userInfo.getPassingYear());
            userResponse.setCgpa(userInfo.getCgpa());
        }
        if (userInfo.getRole().equals("TRAINEE")) {
            userResponse.setDesignation(userInfo.getDesignation());
            userResponse.setExpertise(userInfo.getExpertise());
            userResponse.setJoiningDate(userInfo.getJoiningDate());
        }
        return userResponse;
    }
}