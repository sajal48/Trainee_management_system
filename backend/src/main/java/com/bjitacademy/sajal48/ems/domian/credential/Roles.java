package com.bjitacademy.sajal48.ems.domian.credential;
public enum Roles {
    ADMIN("ADMIN"),
    TRAINER("TRAINER"),
    TRAINEE("TRAINEE");
    private final String role;
    Roles(String role) {
        this.role = role;
    }
    public String get() {
        return role;
    }
}
