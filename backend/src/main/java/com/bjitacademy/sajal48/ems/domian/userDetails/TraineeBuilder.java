package com.bjitacademy.sajal48.ems.domian.userDetails;
public class TraineeBuilder {
    private final UserDetails userDetails;
    public TraineeBuilder() {
        this.userDetails = new UserDetails();
    }
    public static UserDetails getTraineeUser(UserDetails userDetails) {
        return new TraineeBuilder()
                .setUserId(userDetails.getUserId())
                .setEmail(userDetails.getEmail())
                .setFullName(userDetails.getFullName())
                .setContactNo(userDetails.getContactNo())
                .setDob(userDetails.getDob())
                .setEducationalInstitute(userDetails.getEducationalInstitute())
                .setDegreeName(userDetails.getDegreeName())
                .setPassingYear(userDetails.getPassingYear())
                .setCgpa(userDetails.getCgpa())
                .setPresentAddress(userDetails.getPresentAddress())
                .setProfilePictureId(userDetails.getProfilePictureId())
                .build();
    }
    public TraineeBuilder setUserId(Long userId) {
        this.userDetails.setUserId(userId);
        return this;
    }
    public TraineeBuilder setFullName(String fullName) {
        this.userDetails.setFullName(fullName);
        return this;
    }
    public TraineeBuilder setContactNo(String contactNo) {
        this.userDetails.setContactNo(contactNo);
        return this;
    }
    public TraineeBuilder setDob(String dob) {
        this.userDetails.setDob(dob);
        return this;
    }
    public TraineeBuilder setEducationalInstitute(String educationalInstitute) {
        this.userDetails.setEducationalInstitute(educationalInstitute);
        return this;
    }
    public TraineeBuilder setDegreeName(String degreeName) {
        this.userDetails.setDegreeName(degreeName);
        return this;
    }
    public TraineeBuilder setPassingYear(String passingYear) {
        this.userDetails.setPassingYear(passingYear);
        return this;
    }
    public TraineeBuilder setCgpa(String cgpa) {
        this.userDetails.setCgpa(cgpa);
        return this;
    }
    public TraineeBuilder setPresentAddress(String presentAddress) {
        this.userDetails.setPresentAddress(presentAddress);
        return this;
    }
    public TraineeBuilder setProfilePictureId(Long profilePictureId) {
        this.userDetails.setProfilePictureId(profilePictureId);
        return this;
    }
    public TraineeBuilder setEmail(String email) {
        this.userDetails.setEmail(email);
        return this;
    }
    public UserDetails build() {
        this.userDetails.setRole("TRAINEE");
        return this.userDetails;
    }
}