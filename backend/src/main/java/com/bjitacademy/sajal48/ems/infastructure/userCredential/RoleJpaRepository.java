package com.bjitacademy.sajal48.ems.infastructure.userCredential;
import com.bjitacademy.sajal48.ems.domian.credential.UserRole;
import com.bjitacademy.sajal48.ems.domian.credential.UserRoleRepository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface RoleJpaRepository extends UserRoleRepository, JpaRepository<UserRole, Long> {
}
