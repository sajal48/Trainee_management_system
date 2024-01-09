package com.bjitacademy.sajal48.ems.infastructure.userCredential;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredential;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredentialRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface UserCredentialJpaRepository extends UserCredentialRepository, JpaRepository<UserCredential, Long> {
}
