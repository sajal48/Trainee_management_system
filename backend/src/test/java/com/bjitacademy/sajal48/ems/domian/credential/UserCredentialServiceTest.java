package com.bjitacademy.sajal48.ems.domian.credential;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.exception.UserCredentialException;
import com.bjitacademy.sajal48.ems.domian.exception.UserNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
class UserCredentialServiceTest {
    @Mock
    private UserCredentialRepository userCredentialRepository;
    @Mock
    private UserRoleRepository userRoleRepository;
    @InjectMocks
    private UserCredentialService userCredentialService;
    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    @Test
    void addDefaultRoles_RolesNotExistInDatabase_AddsDefaultRoles() {
        // Arrange
        when(userRoleRepository.findByName("ADMIN")).thenReturn(null);
        when(userRoleRepository.findByName("TRAINER")).thenReturn(null);
        when(userRoleRepository.findByName("TRAINEE")).thenReturn(null);
        // Act
        userCredentialService.addDefaultRoles();
        // Assert
        verify(userRoleRepository, times(3)).save(any(UserRole.class));
    }
    @Test
    void addDefaultRoles_RolesExistInDatabase_DoesNotAddDefaultRoles() {
        // Arrange
        when(userRoleRepository.findByName("ADMIN")).thenReturn(new UserRole());
        when(userRoleRepository.findByName("TRAINER")).thenReturn(new UserRole());
        when(userRoleRepository.findByName("TRAINEE")).thenReturn(new UserRole());
        // Act
        userCredentialService.addDefaultRoles();
        // Assert
        verify(userRoleRepository, times(0)).save(any(UserRole.class));
    }
    @Test
    void createUser_ValidUserCredentials_CreatesNewUser() {
        // Arrange
        String email = "test@example.com";
        String password = "testPassword";
        String role = "ADMIN";
        UserRole userRole = new UserRole();
        userRole.setName(role);
        when(userRoleRepository.findByName(role)).thenReturn(userRole);
        when(userCredentialRepository.findByEmail(email)).thenReturn(null);
        when(userCredentialRepository.save(any(UserCredential.class))).thenReturn(new UserCredential(1L, email, password, userRole));
        // Act
        Long userId = userCredentialService.createUser(email, password, role);
        // Assert
        assertEquals(1L, userId);
    }
    @Test
    void createUser_UserWithEmailExists_ThrowsUserCredentialException() {
        // Arrange
        String email = "existing@example.com";
        String password = "testPassword";
        String role = "ADMIN";
        UserRole userRole = new UserRole();
        userRole.setName(role);
        when(userRoleRepository.findByName(role)).thenReturn(userRole);
        when(userCredentialRepository.findByEmail(email)).thenReturn(new UserCredential());
        // Act & Assert
        assertThrows(UserCredentialException.class, () -> userCredentialService.createUser(email, password, role));
    }
    @Test
    void createUser_InvalidRole_ThrowsUserCredentialException() {
        // Arrange
        String email = "test@example.com";
        String password = "testPassword";
        String role = "INVALID_ROLE";
        when(userRoleRepository.findByName(role)).thenReturn(null);
        // Act & Assert
        assertThrows(UserCredentialException.class, () -> userCredentialService.createUser(email, password, role));
    }
    @Test
    void verifyUser_ValidUserCredentials_ReturnsVerifiedUser() {
        // Arrange
        String email = "test@example.com";
        String password = "testPassword";
        UserCredential userCredential = new UserCredential();
        userCredential.setEmail(email);
        userCredential.setPassword(password);
        when(userCredentialRepository.findByEmail(email)).thenReturn(userCredential);
        // Act
        UserCredential verifiedUser = userCredentialService.verifyUser(email, password);
        // Assert
        assertNotNull(verifiedUser);
        assertEquals(email, verifiedUser.getEmail());
        assertEquals(password, verifiedUser.getPassword());
    }
    @Test
    void verifyUser_UserNotFound_ThrowsUserCredentialException() {
        // Arrange
        String email = "nonexistent@example.com";
        String password = "testPassword";
        when(userCredentialRepository.findByEmail(email)).thenReturn(null);
        // Act & Assert
        assertThrows(UserCredentialException.class, () -> userCredentialService.verifyUser(email, password));
    }
    @Test
    void verifyUser_WrongPassword_ThrowsUserCredentialException() {
        // Arrange
        String email = "test@example.com";
        String correctPassword = "correctPassword";
        String wrongPassword = "wrongPassword";
        UserCredential userCredential = new UserCredential();
        userCredential.setEmail(email);
        userCredential.setPassword(correctPassword);
        when(userCredentialRepository.findByEmail(email)).thenReturn(userCredential);
        // Act & Assert
        assertThrows(UserCredentialException.class, () -> userCredentialService.verifyUser(email, wrongPassword));
    }
    @Test
    void getUserByEmail_ExistingUserEmail_ReturnsUserCredential() {
        // Arrange
        String email = "test@example.com";
        UserCredential userCredential = new UserCredential();
        userCredential.setEmail(email);
        when(userCredentialRepository.findByEmail(email)).thenReturn(userCredential);
        // Act
        UserCredential retrievedUser = userCredentialService.getUserByEmail(email);
        // Assert
        assertNotNull(retrievedUser);
        assertEquals(email, retrievedUser.getEmail());
    }
    @Test
    void getUserByEmail_NonExistingUserEmail_ThrowsUserNotFoundException() {
        // Arrange
        String email = "nonexistent@example.com";
        when(userCredentialRepository.findByEmail(email)).thenReturn(null);
        // Act & Assert
        assertThrows(UserNotFoundException.class, () -> userCredentialService.getUserByEmail(email));
    }
    @Test
    void updatePassword_ExistingUserEmail_UpdatesPassword() {
        // Arrange
        String email = "test@example.com";
        String newPassword = "newPassword";
        UserCredential userCredential = new UserCredential();
        userCredential.setEmail(email);
        when(userCredentialRepository.findByEmail(email)).thenReturn(userCredential);
        when(userCredentialRepository.save(any(UserCredential.class))).thenReturn(userCredential);
        // Act
        userCredentialService.updatePassword(email, newPassword);
        // Assert
        assertEquals(newPassword, userCredential.getPassword());
    }
    @Test
    void updatePassword_NonExistingUserEmail_ThrowsUserNotFoundException() {
        // Arrange
        String email = "nonexistent@example.com";
        String newPassword = "newPassword";
        when(userCredentialRepository.findByEmail(email)).thenReturn(null);
        // Act & Assert
        assertThrows(UserNotFoundException.class, () -> userCredentialService.updatePassword(email, newPassword));
    }
    @Test
    void addDefaultRoles_ExceptionWhileAddingRoles_ThrowsDatabaseException() {
        // Arrange
        List<String> defaultRoles = List.of("ADMIN", "TRAINER", "TRAINEE");
        when(userRoleRepository.findByName(anyString())).thenReturn(null);
        doThrow(new RuntimeException("Database error")).when(userRoleRepository).save(any(UserRole.class));
        // Act & Assert
        assertThrows(DatabaseException.class, userCredentialService::addDefaultRoles);
    }
}
