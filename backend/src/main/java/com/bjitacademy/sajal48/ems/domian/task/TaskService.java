package com.bjitacademy.sajal48.ems.domian.task;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.transaction.annotation.Transactional;

import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class TaskService {
    private final TaskRepository taskRepository;
    private final TaskSubMissionRepository taskSubMissionRepository;
    public TaskService(TaskRepository taskRepository, TaskSubMissionRepository taskSubMissionRepository) {
        this.taskRepository = taskRepository;
        this.taskSubMissionRepository = taskSubMissionRepository;
    }
    /**
     * Creates a new Task with the provided task data and saves it to the database.
     *
     * @param task The Task object containing the task details to be created.
     * @return The created Task object.
     * @throws DateTimeException If there is an error while generating or setting the creation date.
     * @throws DatabaseException If there is an error creating the task in the database.
     */
    @Transactional
    public Task createTask(Task task) {
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(DATE_FORMAT);
        String formattedDate = currentDate.format(formatter);
        try {
            task.setCreatedAt(formattedDate);
            return taskRepository.save(task);
        } catch (Exception e) {
            throw new DatabaseException(TASK_ADD_FAILURE);
        }
    }
    /**
     * Updates a Task with the provided task data.
     *
     * @param task The updated Task object containing the new values.
     * @param id   The ID of the Task to be updated.
     * @return The updated Task object.
     * @throws DatabaseException      If there is an error updating the task in the database.
     * @throws NoSuchElementException – if no value is present
     */
    @Transactional
    @CachePut(value = "Task", key = "#id")
    public Task updateTask(Task task, Long id) {
        var data = taskRepository.findById(id);
        Task taskFromDb = data.orElseThrow();
        if (task.getAssignedBy() != null) {
            taskFromDb.setAssignedBy(task.getAssignedBy());
        }
        if (task.getBatchId() != null) {
            taskFromDb.setBatchId(task.getBatchId());
        }
        if (task.getTitle() != null) {
            taskFromDb.setTitle(task.getTitle());
        }
        if (task.getDescription() != null) {
            taskFromDb.setDescription(task.getDescription());
        }
        if (task.getTaskType() != null) {
            taskFromDb.setTaskType(task.getTaskType());
        }
        if (task.getFileId() != null) {
            taskFromDb.setFileId(task.getFileId());
        }
        if (task.getSubmissionDate() != null) {
            taskFromDb.setSubmissionDate(task.getSubmissionDate());
        }
        try {
            return taskRepository.save(taskFromDb);
        } catch (Exception e) {
            throw new DatabaseException(TASK_UPDATE_FAILURE);
        }
    }
    /**
     * Retrieves a Task by its ID from the database.
     *
     * @param id The ID of the Task to retrieve.
     * @return The retrieved Task object.
     * @throws NoSuchElementException If no Task is found with the given ID.
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "Task", key = "#id")
    public Task getTaskById(Long id) {
        return taskRepository.findById(id).orElseThrow();
    }
    /**
     * Retrieves a list of Tasks based on the provided batch ID and task type.
     * If either batch ID or task type is null, the method returns all tasks.
     *
     * @param batchId  The ID of the batch. Can be null.
     * @param taskType The type of the task. Can be null.
     * @return A list of Task objects matching the provided criteria.
     * @throws DatabaseException If there is an error fetching tasks from the database.
     */
    @Transactional(readOnly = true)
    public List<Task> getTasksQuery(Long batchId, String taskType) {
        try {
            if (batchId == null && taskType == null) {
                return taskRepository.findAll();
            } else if (batchId != null && taskType == null) {
                return taskRepository.findAllByBatchId(batchId);
            } else {
                return taskRepository.findAllByBatchIdAndTaskType(batchId, taskType);
            }
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Submits a task submission and saves it to the database.
     *
     * @param taskSubmission The TaskSubmission object to be submitted.
     * @return The submitted TaskSubmission object.
     * @throws DatabaseException If there is an error saving the task submission in the database.
     */
    @Transactional
    public TaskSubmission submitTask(TaskSubmission taskSubmission) throws DatabaseException {
        try {
            return taskSubMissionRepository.save(taskSubmission);
        } catch (Exception e) {
            throw new DatabaseException(TASK_SUBMISSION_FAILURE);
        }
    }
    /**
     * Retrieves a Submission by its ID from the database.
     *
     * @param id The ID of the Submission to retrieve.
     * @return The retrieved TaskSubmission object.
     * @throws NoSuchElementException If no Submission is found with the given ID.
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "TaskSubmission", key = "#id")
    public TaskSubmission getSubmissionById(Long id) {
        return taskSubMissionRepository.findById(id).orElseThrow();
    }
    /**
     * Retrieves a list of task submissions by the given task ID.
     *
     * @param taskId The ID of the task.
     * @return A list of TaskSubmission objects associated with the task ID.
     */
    @Transactional(readOnly = true)
    public List<TaskSubmission> getSubmissionByTaskId(Long taskId) {
        return taskSubMissionRepository.findAllByTaskId(taskId);
    }
}
