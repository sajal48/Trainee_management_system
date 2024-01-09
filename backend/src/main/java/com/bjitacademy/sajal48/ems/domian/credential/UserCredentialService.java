package com.bjitacademy.sajal48.ems.domian.credential;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.exception.UserCredentialException;
import com.bjitacademy.sajal48.ems.domian.exception.UserNotFoundException;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class UserCredentialService {
    private final UserCredentialRepository userRepository;
    private final UserRoleRepository roleRepository;
    public UserCredentialService(UserCredentialRepository userRepository, UserRoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }
    /**
     * Adds default roles (ADMIN, TRAINER, TRAINEE) to the role database if they are not already present.
     *
     * @throws DatabaseException if there is an error accessing the database.
     */
    public void addDefaultRoles() {
        List<String> defaultRoles = Arrays.asList("ADMIN", "TRAINER", "TRAINEE");
        try {
            for (String roleName : defaultRoles) {
                UserRole existingRole = roleRepository.findByName(roleName);
                if (existingRole == null) {
                    UserRole newRole = new UserRole();
                    newRole.setName(roleName);
                    newRole.setDescription("Default role: " + roleName);
                    roleRepository.save(newRole);
                }
            }
        } catch (Exception ex) {
            throw new DatabaseException(DEFAULT_ROLE_INITIALIZATION_FAILURE);
        }
    }
    /**
     * Creates a new user with the provided email, password, and role.
     *
     * @param email    the email of the user
     * @param password the password of the user
     * @param role     the role of the user
     * @return the ID of the newly created user
     * @throws UserCredentialException if a user with the provided email already exists
     */
    @Transactional
    public Long createUser(String email, String password, String role) {
        // Check if user already exists by email
        if (userRepository.findByEmail(email) != null) {
            throw new UserCredentialException(USERS_ALREADY_EXIST);
        }
        UserRole userRole = roleRepository.findByName(role);
        if (userRole == null) {
            throw new UserCredentialException(ROLE_NOT_FOUND);
        }
        UserCredential newUser = new UserCredential(null, email, password, userRole);
        return userRepository.save(newUser).getUserId();
    }
    /**
     * Verifies a user with the provided email and password.
     *
     * @param email    the email of the user
     * @param password the password of the user
     * @return the verified user entity
     * @throws UserCredentialException if the user is not found or the password is incorrect
     */
    @Transactional(readOnly = true)
    public UserCredential verifyUser(String email, String password) {
        UserCredential user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        throw new UserCredentialException(WRONG_CREDENTIAL);
    }
    /**
     * Retrieves a user with the provided email.
     *
     * @param email the email of the user
     * @return the user entity with the matching email
     * @throws UserNotFoundException if the user is not found
     */
    @Transactional(readOnly = true)
    public UserCredential getUserByEmail(String email) {
        UserCredential user = userRepository.findByEmail(email);
        if (user != null) {
            return user;
        }
        throw new UserNotFoundException(USER_NOT_FOUND + email);
    }
    /**
     * Updates the password of a user with the provided email.
     *
     * @param email       the email of the user
     * @param newPassword the new password to be set for the user
     * @throws UserNotFoundException if the user is not found with the provided email
     */
    @Transactional
    public void updatePassword(String email, String newPassword) {
        UserCredential user = userRepository.findByEmail(email);
        if (user != null) {
            user.setPassword(newPassword);
            userRepository.save(user);
            return;
        }
        throw new UserNotFoundException(USER_NOT_FOUND + email);
    }
}
