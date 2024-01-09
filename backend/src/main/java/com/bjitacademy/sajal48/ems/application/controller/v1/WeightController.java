package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.WeightageDto;
import com.bjitacademy.sajal48.ems.domian.evaluation.Weightage;
import com.bjitacademy.sajal48.ems.domian.evaluation.WeightageService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;
@RestController
@RequestMapping("api/v1/weight")
@RequiredArgsConstructor
public class WeightController {
    private final WeightageService weightageService;
    @PostConstruct
    public void defaultWeightage() {
        weightageService.initializeWeightage();
    }
    @Secured({"ADMIN"})
    @GetMapping
    public ResponseEntity<?> getWeightage() {
        Weightage weightage = weightageService.getWeightage();
        return new ResponseEntity<>(weightage, HttpStatus.OK);
    }
    @Secured({"ADMIN"})
    @PutMapping
    public ResponseEntity<?> updateWeightage(@RequestBody WeightageDto weightageDto) {
        Weightage weightage = weightageService.updateWeightage(WeightageDto.weightageFromWeightageDto(weightageDto));
        return new ResponseEntity<>(weightage, HttpStatus.OK);
    }
}
