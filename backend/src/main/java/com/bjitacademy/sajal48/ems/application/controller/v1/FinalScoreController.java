package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.FeedbackDTO;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FeedBack;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.FinalScore;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.ScoreGenerationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("api/v1/final-score")
@RequiredArgsConstructor
public class FinalScoreController {
    private final ScoreGenerationService scoreGenerationService;
    @Secured({"ADMIN", "TRAINER"})
    @GetMapping("/{batchId}")
    public ResponseEntity<?> generateScore(@PathVariable Long batchId, @RequestParam boolean recalculate) {
        List<FinalScore> scores = scoreGenerationService.generateScore(batchId, recalculate);
        return new ResponseEntity<>(scores, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @GetMapping()
    public ResponseEntity<?> getAllScore() {
        List<FinalScore> scores = scoreGenerationService.getAll();
        return new ResponseEntity<>(scores, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PostMapping("/feedback/{id}")
    public ResponseEntity<?> addRemarks(@PathVariable Long id, @RequestBody FeedbackDTO dto) {
        FinalScore finalScore = scoreGenerationService.addFeedback(id, FeedbackDTO.toEntity(dto));
        return new ResponseEntity<>(finalScore, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PutMapping("/feedback/{id}")
    public ResponseEntity<?> updateRemarks(@PathVariable Long id, @RequestParam String message) {
        FeedBack feedBack = scoreGenerationService.update(id, message);
        return new ResponseEntity<>(feedBack, HttpStatus.OK);
    }
}
