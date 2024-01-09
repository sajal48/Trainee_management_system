package com.bjitacademy.sajal48.ems.application.config;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.springframework.web.bind.annotation.RestController;
@RestController
@OpenAPIDefinition(info =
@Info(
        title = "Evaluation Management System",
        version = "1.0",
        description = "Documentation for Evaluation Management System",
        contact = @Contact(name = "Sajal halder", email = "sajal.halder@bjitcademy.com")
),
        security = @SecurityRequirement(name = "bearerAuth")
)
public class OpenAPIConfig {
}