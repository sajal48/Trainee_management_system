package com.bjitacademy.sajal48.ems.domian.exception;
import static com.bjitacademy.sajal48.ems.domian.strings.Values.DATABASE_EXCEPTION_DEFAULT_PLACEHOLDER;
public class DatabaseException extends RuntimeException {
    public DatabaseException(String message) {
        super(DATABASE_EXCEPTION_DEFAULT_PLACEHOLDER + message);
    }
}
