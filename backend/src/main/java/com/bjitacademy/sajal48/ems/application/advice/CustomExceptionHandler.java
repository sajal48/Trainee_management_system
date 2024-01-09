package com.bjitacademy.sajal48.ems.application.advice;
import com.bjitacademy.sajal48.ems.application.dto.ErrorResponse;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.exception.UserCredentialException;
import com.bjitacademy.sajal48.ems.domian.exception.UserNotFoundException;
import io.jsonwebtoken.ExpiredJwtException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.NoSuchElementException;
@RestControllerAdvice
public class CustomExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleValidationException(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        System.out.println(ex.getMessage());
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        System.out.println(errors);
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.BAD_REQUEST, errors.values().iterator().next());
        System.out.println(errorResponse);
        return new ResponseEntity<>(errorResponse, errorResponse.getStatus());
    }
    @ExceptionHandler({DatabaseException.class, UserCredentialException.class, UserNotFoundException.class, BadCredentialsException.class})
    public ResponseEntity<Object> handleUserCredentialException(Exception ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_ACCEPTABLE, ex.getMessage());
        return new ResponseEntity<>(errorResponse, errorResponse.getStatus());
    }
    @ExceptionHandler({IOException.class, NoSuchElementException.class})
    public ResponseEntity<Object> handleFileExceptions(Exception ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.NOT_FOUND, ex.getMessage());
        return new ResponseEntity<>(errorResponse, errorResponse.getStatus());
    }
    @ExceptionHandler({ExpiredJwtException.class})
    public ResponseEntity<Object> expiredTokenHandler(Exception ex) {
        ErrorResponse errorResponse = new ErrorResponse(HttpStatus.valueOf(498), ex.getMessage());
        return new ResponseEntity<>(errorResponse, errorResponse.getStatus());
    }
}

