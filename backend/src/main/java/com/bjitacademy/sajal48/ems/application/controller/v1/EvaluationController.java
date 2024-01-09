package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.FinalProjectEvaluationDTO;
import com.bjitacademy.sajal48.ems.application.dto.ManagersEvaluationDTO;
import com.bjitacademy.sajal48.ems.application.dto.TaskEvaluationDTO;
import com.bjitacademy.sajal48.ems.application.dto.TaskEvaluationUpdateDTO;
import com.bjitacademy.sajal48.ems.domian.evaluation.*;
import com.bjitacademy.sajal48.ems.domian.task.TaskTypes;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("api/v1/evaluation")
@RequiredArgsConstructor
public class EvaluationController {
    private final EvaluationService evaluationService;
    @Secured({"ADMIN", "TRAINER"})
    @PostMapping
    public ResponseEntity<?> uploadTaskEvaluation(@RequestBody TaskEvaluationDTO taskEvaluationDTO) {
        TaskEvaluation evaluation = evaluationService.saveTaskEvaluation(TaskEvaluationDTO.fromDto(taskEvaluationDTO), TaskTypes.valueOf(taskEvaluationDTO.getTaskType()));
        return new ResponseEntity<>(evaluation, HttpStatus.CREATED);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PutMapping("/{id}")
    public ResponseEntity<?> updateTaskEvaluation(@Valid @RequestBody TaskEvaluationUpdateDTO taskEvaluationDTO, @PathVariable Long id) {
        TaskEvaluation evaluation = evaluationService.updateTaskEvaluation(TaskEvaluationUpdateDTO.fromDto(taskEvaluationDTO), id);
        return new ResponseEntity<>(evaluation, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @GetMapping
    public ResponseEntity<?> getEvaluation(@RequestParam Long batchId, @RequestParam String taskType, @RequestParam(required = false) String date) {
        if (TaskTypes.valueOf(taskType).equals(TaskTypes.FINAL_PROJECT)) {
            List<FinalProjectEvaluation> evaluations = evaluationService.getFinalProjectEvaluation(batchId);
            return new ResponseEntity<>(evaluations, HttpStatus.OK);
        }
        if (TaskTypes.valueOf(taskType).equals(TaskTypes.MANAGERS)) {
            List<ManagerEvaluation> evaluations = evaluationService.getManagersEvaluation(batchId);
            return new ResponseEntity<>(evaluations, HttpStatus.OK);
        }
        if (TaskTypes.valueOf(taskType).equals(TaskTypes.CEO)) {
            List<AptitudeAndHrEvaluation> evaluations = evaluationService.getAptitudeAndHrEvaluation(batchId);
            return new ResponseEntity<>(evaluations, HttpStatus.OK);
        }
        List<TaskEvaluation> evaluations = evaluationService.getEvaluationByBatchIdAndTaskType(batchId, TaskTypes.valueOf(taskType), date);
        return new ResponseEntity<>(evaluations, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PostMapping("/final-project")
    public ResponseEntity<?> uploadFinalEvaluation(@Valid @RequestBody FinalProjectEvaluationDTO finalProjectEvaluationDTO) {
        FinalProjectEvaluation evaluation = evaluationService.saveFinalProjectEvaluation(FinalProjectEvaluationDTO.toEntity(finalProjectEvaluationDTO));
        return new ResponseEntity<>(evaluation, HttpStatus.CREATED);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PutMapping("/final-project/{id}")
    public ResponseEntity<?> updateFinalEvaluation(@Valid @RequestBody FinalProjectEvaluationDTO finalProjectEvaluationDTO, @PathVariable Long id) {
        FinalProjectEvaluation evaluation = evaluationService.updateFinalProjectEvaluation(FinalProjectEvaluationDTO.toEntity(finalProjectEvaluationDTO), id);
        return new ResponseEntity<>(evaluation, HttpStatus.CREATED);
    }
    @Secured({"ADMIN"})
    @PostMapping("/manager")
    public ResponseEntity<?> uploadManagersEvaluation(@Valid @RequestBody ManagersEvaluationDTO managersEvaluationDTO) {
        ManagerEvaluation evaluation = evaluationService.saveManagerEvaluation(ManagersEvaluationDTO.toEntity(managersEvaluationDTO));
        return new ResponseEntity<>(evaluation, HttpStatus.CREATED);
    }
    @Secured({"ADMIN"})
    @PutMapping("/manager/{id}")
    public ResponseEntity<?> updateManagersEvaluation(@Valid @RequestBody ManagersEvaluationDTO managersEvaluationDTO, @PathVariable Long id) {
        ManagerEvaluation evaluation = evaluationService.updateManagerEvaluation(ManagersEvaluationDTO.toEntity(managersEvaluationDTO), id);
        return new ResponseEntity<>(evaluation, HttpStatus.OK);
    }
    @Secured({"ADMIN"})
    @PostMapping("/ceo")
    public ResponseEntity<?> uploadHrEvaluation(@Valid @RequestBody AptitudeAndHrEvaluation aptitudeAndHrEvaluation) {
        AptitudeAndHrEvaluation evaluation = evaluationService.saveAptitudeAndHrEvaluation(aptitudeAndHrEvaluation);
        return new ResponseEntity<>(evaluation, HttpStatus.CREATED);
    }
    @Secured({"ADMIN"})
    @PutMapping("/ceo/{id}")
    public ResponseEntity<?> updateHrEvaluation(@Valid @RequestBody AptitudeAndHrEvaluation aptitudeAndHrEvaluation, @PathVariable Long id) {
        AptitudeAndHrEvaluation evaluation = evaluationService.updateAptitudeAndHrEvaluation(aptitudeAndHrEvaluation, id);
        return new ResponseEntity<>(evaluation, HttpStatus.OK);
    }
}
