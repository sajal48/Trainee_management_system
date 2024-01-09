package com.bjitacademy.sajal48.ems.application.dto;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;
@Data
public class UserUpdateRequest {
    private static UserDetails userInfo;
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
    MultipartFile file;
    public static UserDetails toUserInfo(UserUpdateRequest userRequest) {
        userInfo = new UserDetails();
        userInfo.setFullName(userRequest.getFullName());
        userInfo.setProfilePictureId(userRequest.profilePictureId);
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