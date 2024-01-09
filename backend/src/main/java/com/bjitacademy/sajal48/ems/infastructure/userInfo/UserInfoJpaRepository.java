package com.bjitacademy.sajal48.ems.infastructure.userInfo;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetailsRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface UserInfoJpaRepository extends UserDetailsRepository, JpaRepository<UserDetails, Long> {
}
