package com.bjitacademy.sajal48.ems.domian.userDetails;
import java.util.List;
import java.util.Optional;
public interface UserDetailsRepository {
    UserDetails save(UserDetails userDetails);
    Optional<UserDetails> findByUserId(Long id);
    Optional<UserDetails> findByEmail(String email);
    List<UserDetails> findAllByRole(String role);
    long countByRole(String role);
}
