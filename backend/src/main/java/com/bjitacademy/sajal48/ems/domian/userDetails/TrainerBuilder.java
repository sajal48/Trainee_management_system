package com.bjitacademy.sajal48.ems.domian.userDetails;
public class TrainerBuilder {
    private final UserDetails userDetails;
    public TrainerBuilder() {
        this.userDetails = new UserDetails();
    }
    public static UserDetails getTrainerUser(UserDetails userDetails) {
        return new TrainerBuilder()
                .setUserId(userDetails.getUserId())
                .setEmail(userDetails.getEmail())
                .setFullName(userDetails.getFullName())
                .setContactNo(userDetails.getContactNo())
                .setDesignation(userDetails.getDesignation())
                .setExpertise(userDetails.getExpertise())
                .setJoiningDate(userDetails.getJoiningDate())
                .setPresentAddress(userDetails.getPresentAddress())
                .setProfilePictureId(userDetails.getProfilePictureId())
                .build();
    }
    public TrainerBuilder setUserId(Long userId) {
        this.userDetails.setUserId(userId);
        return this;
    }
    public TrainerBuilder setFullName(String fullName) {
        this.userDetails.setFullName(fullName);
        return this;
    }
    public TrainerBuilder setContactNo(String contactNo) {
        this.userDetails.setContactNo(contactNo);
        return this;
    }
    public TrainerBuilder setDesignation(String designation) {
        this.userDetails.setDesignation(designation);
        return this;
    }
    public TrainerBuilder setExpertise(String expertise) {
        this.userDetails.setExpertise(expertise);
        return this;
    }
    public TrainerBuilder setJoiningDate(String joiningDate) {
        this.userDetails.setJoiningDate(joiningDate);
        return this;
    }
    public TrainerBuilder setEmail(String email) {
        this.userDetails.setEmail(email);
        return this;
    }
    public TrainerBuilder setPresentAddress(String presentAddress) {
        this.userDetails.setPresentAddress(presentAddress);
        return this;
    }
    public TrainerBuilder setProfilePictureId(Long profilePictureId) {
        this.userDetails.setProfilePictureId(profilePictureId);
        return this;
    }
    public UserDetails build() {
        this.userDetails.setRole("TRAINER");
        return this.userDetails;
    }
}
