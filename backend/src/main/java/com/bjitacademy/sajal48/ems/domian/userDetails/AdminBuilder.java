package com.bjitacademy.sajal48.ems.domian.userDetails;
public class AdminBuilder {
    private final UserDetails userDetails;
    public AdminBuilder() {
        this.userDetails = new UserDetails();
    }
    public static UserDetails getAdminUser(UserDetails userDetails) {
        return new AdminBuilder()
                .setUserId(userDetails.getUserId())
                .setEmail(userDetails.getEmail())
                .setFullName(userDetails.getFullName())
                .setContactNo(userDetails.getContactNo())
                .setPresentAddress(userDetails.getPresentAddress())
                .setProfilePictureId(userDetails.getProfilePictureId())
                .build();
    }
    public AdminBuilder setUserId(Long userId) {
        this.userDetails.setUserId(userId);
        return this;
    }
    public AdminBuilder setFullName(String fullName) {
        this.userDetails.setFullName(fullName);
        return this;
    }
    public AdminBuilder setContactNo(String contactNo) {
        this.userDetails.setContactNo(contactNo);
        return this;
    }
    public AdminBuilder setPresentAddress(String presentAddress) {
        this.userDetails.setPresentAddress(presentAddress);
        return this;
    }
    public AdminBuilder setProfilePictureId(Long profilePictureId) {
        this.userDetails.setProfilePictureId(profilePictureId);
        return this;
    }
    public AdminBuilder setEmail(String email) {
        this.userDetails.setEmail(email);
        return this;
    }
    public UserDetails build() {
        this.userDetails.setRole("ADMIN");
        return this.userDetails;
    }
}