package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.UserUpdateRequest;
import com.bjitacademy.sajal48.ems.domian.file.FileService;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserCount;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/user")
public class UserController {
    private final UserInfoService userInfoService;
    private final FileService fileService;
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @PostMapping("/{userId}")
    public ResponseEntity<?> updateUser(@ModelAttribute UserUpdateRequest userUpdateRequest, @PathVariable Long userId) {
        Long fileId = null;
        if (userUpdateRequest.getFile() != null) {
            fileId = fileService.uploadFile(userUpdateRequest.getFile()).getId();
        }
        userUpdateRequest.setProfilePictureId(fileId);
        UserDetails userDetails = userInfoService.updateUserInfo(userId, UserUpdateRequest.toUserInfo(userUpdateRequest));
        return new ResponseEntity<>(userDetails, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/{userId}")
    public ResponseEntity<?> getUser(@PathVariable Long userId) {
        UserDetails userDetails = userInfoService.getUserDetails(userId);
        return new ResponseEntity<>(userDetails, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping
    public ResponseEntity<?> getUserQuery(@RequestParam String userType) {
        List<UserDetails> users = userInfoService.getUserByRoles(userType.toUpperCase());
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/count")
    public ResponseEntity<?> getUserCount() {
        UserCount userCount = userInfoService.getCounts();
        return new ResponseEntity<>(userCount, HttpStatus.OK);
    }
}
