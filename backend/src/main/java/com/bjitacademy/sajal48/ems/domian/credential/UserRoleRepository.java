package com.bjitacademy.sajal48.ems.domian.credential;
import java.util.Optional;
public interface UserRoleRepository {
    UserRole findByName(String name);
    Optional<UserRole> findById(long id);
    UserRole save(UserRole entity);
    void deleteById(long id);
}