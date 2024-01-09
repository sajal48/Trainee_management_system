package com.bjitacademy.sajal48.ems.domian.credential;
public interface UserCredentialRepository {
    UserCredential save(UserCredential userEntity);
    UserCredential findByEmail(String email);
    void deleteByEmail(String email);
}