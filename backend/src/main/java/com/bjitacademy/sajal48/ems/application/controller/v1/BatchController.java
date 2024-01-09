package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.BatchRequest;
import com.bjitacademy.sajal48.ems.domian.batch.Batch;
import com.bjitacademy.sajal48.ems.domian.batch.BatchService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("api/v1/batch")
@RequiredArgsConstructor
public class BatchController {
    private final BatchService batchService;
    @Secured({"ADMIN"})
    @PostMapping
    public ResponseEntity<?> createBatch(@RequestBody BatchRequest batchRequest) {
        Batch batch = batchService.createBatch(BatchRequest.getBatchFromBatchRequest(batchRequest));
        return new ResponseEntity<>(batch, HttpStatus.CREATED);
    }
    @Secured({"ADMIN"})
    @PutMapping("/{id}")
    public ResponseEntity<?> updateBatch(@RequestBody BatchRequest batchRequest, @PathVariable Long id) {
        Batch batch = batchService.updateBatch(BatchRequest.getBatchFromBatchRequest(batchRequest), id, batchRequest.getUserIds());
        return new ResponseEntity<>(batch, HttpStatus.OK);
    }
    @Secured({"ADMIN"})
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteBatch(@PathVariable Long id) {
        batchService.deleteBatch(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/{id}")
    public ResponseEntity<?> getBatch(@PathVariable Long id) {
        Batch batch = batchService.findBatch(id);
        return new ResponseEntity<>(batch, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping()
    public ResponseEntity<?> getBatches() {
        List<Batch> batches = batchService.getAllBatches();
        return new ResponseEntity<>(batches, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/user/{id}")
    public ResponseEntity<?> getBatchByUserId(@PathVariable Long id) {
        Batch batch = batchService.getBatchByUserId(id);
        return new ResponseEntity<>(batch, HttpStatus.OK);
    }
}
