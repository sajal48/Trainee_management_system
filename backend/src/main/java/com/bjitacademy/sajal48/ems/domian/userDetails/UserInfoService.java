package com.bjitacademy.sajal48.ems.domian.userDetails;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class UserInfoService {
    private final UserDetailsRepository userDetailsRepository;
    public UserInfoService(UserDetailsRepository userDetailsRepository) {
        this.userDetailsRepository = userDetailsRepository;
    }
    /**
     * Creates a new entry in the database with the provided user details.
     *
     * @param userId The user ID for the new entry.
     * @param email  The email for the new entry.
     * @param role   The role for the new entry.
     * @throws DatabaseException If an error occurs while adding the user information to the database.
     */
    @Transactional
    public void createEntry(Long userId, String email, String role) {
        try {
            UserDetails userDetails = UserDetails.builder()
                    .userId(userId)
                    .email(email)
                    .role(role)
                    .build();
            userDetailsRepository.save(userDetails);
        } catch (Exception e) {
            throw new DatabaseException(USER_ADD_FAILURE);
        }
    }
    /**
     * Updates the user information for the given user ID with the provided user details.
     *
     * @param id          The ID of the user to update.
     * @param userDetails The updated user details.
     * @return The updated user details after saving to the database.
     * @throws DatabaseException      If an error occurs while updating the user information in the database.
     * @throws NoSuchElementException If no  entry is found.
     */
    @Transactional
    @CachePut(value = "UserDetails", key = "#id")
    public UserDetails updateUserInfo(Long id, UserDetails userDetails) {
        UserDetails existingInfo = userDetailsRepository.findByUserId(id).orElseThrow();
        try {
            // Get the non-null fields of userDetails and set them to existingInfo
            if (userDetails.getFullName() != null) {
                existingInfo.setFullName(userDetails.getFullName());
            }
            if (userDetails.getContactNo() != null) {
                existingInfo.setContactNo(userDetails.getContactNo());
            }
            if (userDetails.getDob() != null) {
                existingInfo.setDob(userDetails.getDob());
            }
            if (userDetails.getEducationalInstitute() != null) {
                existingInfo.setEducationalInstitute(userDetails.getEducationalInstitute());
            }
            if (userDetails.getDegreeName() != null) {
                existingInfo.setDegreeName(userDetails.getDegreeName());
            }
            if (userDetails.getPassingYear() != null) {
                existingInfo.setPassingYear(userDetails.getPassingYear());
            }
            if (userDetails.getCgpa() != null) {
                existingInfo.setCgpa(userDetails.getCgpa());
            }
            if (userDetails.getDesignation() != null) {
                existingInfo.setDesignation(userDetails.getDesignation());
            }
            if (userDetails.getExpertise() != null) {
                existingInfo.setExpertise(userDetails.getExpertise());
            }
            if (userDetails.getJoiningDate() != null) {
                existingInfo.setJoiningDate(userDetails.getJoiningDate());
            }
            if (userDetails.getPresentAddress() != null) {
                existingInfo.setPresentAddress(userDetails.getPresentAddress());
            }
            if (userDetails.getProfilePictureId() != null) {
                existingInfo.setProfilePictureId(userDetails.getProfilePictureId());
            }
            return userDetailsRepository.save(existingInfo);
        } catch (Exception e) {
            throw new DatabaseException(USER_UPDATE_FAILURE);
        }
    }
    /**
     * Retrieves the user details for the given user ID.
     *
     * @param userId The ID of the user to retrieve the details for.
     * @return The user details for the given user ID.
     * @throws DatabaseException      If no user information is found for the given user ID.
     * @throws NoSuchElementException If no  entry is found.
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "UserDetails", key = "#userId")
    public UserDetails getUserDetails(Long userId) {
        return userDetailsRepository.findByUserId(userId).orElseThrow();
    }
    /**
     * Retrieves a list of user details for the given role.
     *
     * @param role The role for which to retrieve the user details.
     * @return A list of user details for the given role.
     * @throws DatabaseException If an error occurs while fetching information from the database.
     */
    @Transactional(readOnly = true)
    public List<UserDetails> getUserByRoles(String role) {
        try {
            return userDetailsRepository.findAllByRole(role);
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    @Transactional(readOnly = true)
    public UserCount getCounts() {
        long adminCount = userDetailsRepository.countByRole("ADMIN");
        long trainerCount = userDetailsRepository.countByRole("TRAINER");
        long traineeCount = userDetailsRepository.countByRole("TRAINEE");
        return UserCount.builder()
                .adminCount(adminCount)
                .trainerCount(trainerCount)
                .traineeCount(traineeCount)
                .build();
    }
}
