package com.bjitacademy.sajal48.ems.application.dto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Data;
@Data
public class UpdatePasswordRequest {
    @Valid
    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Invalid email format")
    String email;
    @NotEmpty(message = "Old Password cannot be empty")
    @Size(min = 6, message = "Old Password must be at least 6 characters long")
    String oldPassword;
    @NotEmpty(message = " New Password cannot be empty")
    @Size(min = 6, message = "New Password must be at least 6 characters long")
    String newPassword;
}