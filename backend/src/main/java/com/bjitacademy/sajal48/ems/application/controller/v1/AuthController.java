package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.AuthenticateResponse;
import com.bjitacademy.sajal48.ems.application.dto.LoginRequest;
import com.bjitacademy.sajal48.ems.application.dto.RegisterRequest;
import com.bjitacademy.sajal48.ems.application.dto.UpdatePasswordRequest;
import com.bjitacademy.sajal48.ems.application.filters.JwtService;
import com.bjitacademy.sajal48.ems.domian.credential.Roles;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredential;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredentialService;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserInfoService;
import jakarta.annotation.PostConstruct;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/auth")
public class AuthController {
    private final UserCredentialService userCredentialService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserInfoService userInfoService;
    @PostConstruct
    public void init() {
        userCredentialService.addDefaultRoles();
    }
    @PostMapping("/register/admin")
    public ResponseEntity<?> registerAdmin(@RequestBody @Valid RegisterRequest registerRequest) {
        Long userId = userCredentialService.createUser(registerRequest.getEmail(), passwordEncoder.encode(registerRequest.getPassword()), Roles.ADMIN.get());
        userInfoService.createEntry(userId, registerRequest.getEmail(), Roles.ADMIN.get());
        return new ResponseEntity<>(userId, HttpStatus.CREATED);
    }
    @PostMapping("/register/trainer")
    public ResponseEntity<?> registerTrainer(@RequestBody @Valid RegisterRequest registerRequest) {
        Long userId = userCredentialService.createUser(registerRequest.getEmail(), passwordEncoder.encode(registerRequest.getPassword()), Roles.TRAINER.get());
        userInfoService.createEntry(userId, registerRequest.getEmail(), Roles.TRAINER.get());
        return new ResponseEntity<>(userId, HttpStatus.CREATED);
    }
    @PostMapping("/register/trainee")
    public ResponseEntity<?> registerTrainee(@RequestBody @Valid RegisterRequest registerRequest) {
        Long userId = userCredentialService.createUser(registerRequest.getEmail(), passwordEncoder.encode(registerRequest.getPassword()), Roles.TRAINEE.get());
        userInfoService.createEntry(userId, registerRequest.getEmail(), Roles.TRAINEE.get());
        return new ResponseEntity<>(userId, HttpStatus.CREATED);
    }
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody @Valid LoginRequest loginRequest) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                loginRequest.getEmail(),
                loginRequest.getPassword()
        ));
        UserCredential userCredential = userCredentialService.getUserByEmail(loginRequest.getEmail());
        String jwtToken = jwtService.generateToken(userCredential);
        return new ResponseEntity<>(new AuthenticateResponse(jwtToken), HttpStatus.OK);
    }
    @PutMapping("/update-password")
    public ResponseEntity<?> updatePassword(@RequestBody @Valid UpdatePasswordRequest updatePasswordRequest) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                updatePasswordRequest.getEmail(),
                updatePasswordRequest.getOldPassword()
        ));
        userCredentialService.updatePassword(updatePasswordRequest.getEmail(), passwordEncoder.encode(updatePasswordRequest.getNewPassword()));
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
