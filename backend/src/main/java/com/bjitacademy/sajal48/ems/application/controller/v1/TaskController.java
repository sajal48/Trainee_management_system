package com.bjitacademy.sajal48.ems.application.controller.v1;
import com.bjitacademy.sajal48.ems.application.dto.TaskDto;
import com.bjitacademy.sajal48.ems.application.dto.TaskSubmitDto;
import com.bjitacademy.sajal48.ems.domian.file.FileService;
import com.bjitacademy.sajal48.ems.domian.task.Task;
import com.bjitacademy.sajal48.ems.domian.task.TaskService;
import com.bjitacademy.sajal48.ems.domian.task.TaskSubmission;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
@RestController
@RequestMapping("api/v1/task")
@RequiredArgsConstructor
public class TaskController {
    private final TaskService taskService;
    private final FileService fileService;
    @Secured({"ADMIN", "TRAINER"})
    @PostMapping()
    public ResponseEntity<?> createTask(@Valid @ModelAttribute TaskDto taskDto) {
        Long fileId = null;
        if (taskDto.getFile() != null) {
            fileId = fileService.uploadFile(taskDto.getFile()).getId();
        }
        Task createdtask = taskService.createTask(TaskDto.toTask(taskDto, fileId));
        return new ResponseEntity<>(createdtask, HttpStatus.CREATED);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping()
    public ResponseEntity<?> getTasks(@RequestParam(required = false) Long batchId, @RequestParam(required = false) String taskType) {
        return new ResponseEntity<>(taskService.getTasksQuery(batchId, taskType), HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/{id}")
    public ResponseEntity<?> getTask(@PathVariable Long id) {
        return new ResponseEntity<>(taskService.getTaskById(id), HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER"})
    @PutMapping("/{id}")
    public ResponseEntity<?> updateTask(@ModelAttribute TaskDto taskDto, @PathVariable Long id) {
        Long fileId = null;
        if (taskDto.getFile() != null) {
            fileId = fileService.uploadFile(taskDto.getFile()).getId();
        }
        Task updatedTask = taskService.updateTask(TaskDto.toTask(taskDto, fileId), id);
        return new ResponseEntity<>(updatedTask, HttpStatus.OK);
    }
    @Secured({"TRAINEE"})
    @PostMapping("/submit")
    public ResponseEntity<?> submitTask(@Valid @ModelAttribute TaskSubmitDto taskSubmitDto) {
        Long fileId = null;
        if (taskSubmitDto.getFile() != null) {
            fileId = fileService.uploadFile(taskSubmitDto.getFile()).getId();
        }
        TaskSubmission submission = taskService.submitTask(TaskSubmitDto.toTaskSubmission(taskSubmitDto, fileId));
        return new ResponseEntity<>(submission, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/submission/{id}")
    public ResponseEntity<?> getSubmissionById(@PathVariable Long id) {
        TaskSubmission taskSubmission = taskService.getSubmissionById(id);
        return new ResponseEntity<>(taskSubmission, HttpStatus.OK);
    }
    @Secured({"ADMIN", "TRAINER", "TRAINEE"})
    @GetMapping("/submission/task/{taskId}")
    public ResponseEntity<?> getSubmissionsByTaskId(@PathVariable Long taskId) {
        List<TaskSubmission> taskSubmissions = taskService.getSubmissionByTaskId(taskId);
        return new ResponseEntity<>(taskSubmissions, HttpStatus.OK);
    }
}
