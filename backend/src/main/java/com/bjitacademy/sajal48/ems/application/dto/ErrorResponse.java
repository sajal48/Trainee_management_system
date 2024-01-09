package com.bjitacademy.sajal48.ems.application.dto;
import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.http.HttpStatus;

import java.util.Map;
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorResponse {
    private final HttpStatus status;
    private final String message;
    private final Map<String, String> errors;
    public ErrorResponse(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
        this.errors = null;
    }
    public ErrorResponse(HttpStatus status, String message, Map<String, String> errors) {
        this.status = status;
        this.message = message;
        this.errors = errors;
    }
    public HttpStatus getStatus() {
        return status;
    }
    public String getMessage() {
        return message;
    }
    public Map<String, String> getErrors() {
        return errors;
    }
}