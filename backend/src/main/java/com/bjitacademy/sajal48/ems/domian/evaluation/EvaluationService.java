package com.bjitacademy.sajal48.ems.domian.evaluation;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.task.TaskTypes;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.DB_DATA_FETCH_FAILURE;
import static com.bjitacademy.sajal48.ems.domian.strings.Values.EVALUATION_UPLOAD_FAILURE;
public class EvaluationService {
    private final TaskEvaluationRepository taskEvaluationRepository;
    private final FinalProjectEvaluationRepository finalProjectEvaluationRepository;
    private final ManagerEvaluationRepository managerEvaluationRepository;
    private final AptitudeAndHrEvaluationRepository aptitudeAndHrEvaluationRepository;
    public EvaluationService(TaskEvaluationRepository taskEvaluationRepository, FinalProjectEvaluationRepository finalProjectEvaluationRepository, ManagerEvaluationRepository managerEvaluationRepository, AptitudeAndHrEvaluationRepository aptitudeAndHrEvaluationRepository) {
        this.taskEvaluationRepository = taskEvaluationRepository;
        this.finalProjectEvaluationRepository = finalProjectEvaluationRepository;
        this.managerEvaluationRepository = managerEvaluationRepository;
        this.aptitudeAndHrEvaluationRepository = aptitudeAndHrEvaluationRepository;
    }
    /**
     * Saves a  task evaluation to the database.
     *
     * @param taskEvaluation The TaskEvaluation object to be saved.
     * @param taskType       taskType
     * @return The saved TaskEvaluation object.
     * @throws DatabaseException If there is an error saving the task evaluation in the database.
     */
    @Transactional
    public TaskEvaluation saveTaskEvaluation(TaskEvaluation taskEvaluation, TaskTypes taskType) {
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        String formattedDate = currentDate.format(formatter);
        taskEvaluation.setEvaluatedOn(formattedDate);
        taskEvaluation.setEvaluationType(taskType.name());
        switch (taskType) {
            case DAILY_TASK -> taskEvaluation.setTotalMark(10.0);
            case MINI_PROJECT -> taskEvaluation.setTotalMark(50.0);
            case MID_PROJECT -> taskEvaluation.setTotalMark(100.0);
        }
        try {
            return taskEvaluationRepository.save(taskEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Saves final project evaluation to the database.
     *
     * @param finalProjectEvaluation The TaskEvaluation object to be saved.
     * @return The saved FinalProjectEvaluation object.
     * @throws DatabaseException If there is an error saving the task evaluation in the database.
     */
    @Transactional
    public FinalProjectEvaluation saveFinalProjectEvaluation(FinalProjectEvaluation finalProjectEvaluation) {
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        String formattedDate = currentDate.format(formatter);
        finalProjectEvaluation.setEvaluatedOn(formattedDate);
        finalProjectEvaluation.setTotalMark(100.0);
        try {
            return finalProjectEvaluationRepository.save(finalProjectEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Updates a task evaluation in the database with the provided task evaluation data.
     *
     * @param taskEvaluation The TaskEvaluation object containing the updated evaluation data.
     * @param id             The ID of the task evaluation to be updated.
     * @return The updated TaskEvaluation object.
     * @throws NoSuchElementException If no  entry is found.
     * @throws DatabaseException      If there is an error updating the task evaluation in the database.
     */
    @Transactional
    public TaskEvaluation updateTaskEvaluation(TaskEvaluation taskEvaluation, Long id) {
        TaskEvaluation existingEvaluation = taskEvaluationRepository.findById(id).orElseThrow();
        // Update the non-null values from taskEvaluation to existingEvaluation
        if (taskEvaluation.getObtainedMark() != null) {
            existingEvaluation.setObtainedMark(taskEvaluation.getObtainedMark());
        }
        if (taskEvaluation.getRequirementUnderstanding() != null) {
            existingEvaluation.setRequirementUnderstanding(taskEvaluation.getRequirementUnderstanding());
        }
        if (taskEvaluation.getExpectedOutput() != null) {
            existingEvaluation.setExpectedOutput(taskEvaluation.getExpectedOutput());
        }
        if (taskEvaluation.getCodeQuality() != null) {
            existingEvaluation.setCodeQuality(taskEvaluation.getCodeQuality());
        }
        if (taskEvaluation.getDemonstrationOrPresentation() != null) {
            existingEvaluation.setDemonstrationOrPresentation(taskEvaluation.getDemonstrationOrPresentation());
        }
        if (taskEvaluation.getLiveCodingOrCodeUnderstanding() != null) {
            existingEvaluation.setLiveCodingOrCodeUnderstanding(taskEvaluation.getLiveCodingOrCodeUnderstanding());
        }
        try {
            return taskEvaluationRepository.save(existingEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Updates a finalProjectEvaluation evaluation in the database with the provided  evaluation data.
     *
     * @param finalProjectEvaluation The TaskEvaluation object containing the updated evaluation data.
     * @param id                     The ID of the task evaluation to be updated.
     * @return The updated FinalProjectEvaluation object.
     * @throws NoSuchElementException If no  entry is found.
     * @throws DatabaseException      If there is an error updating the task evaluation in the database.
     */
    @Transactional
    public FinalProjectEvaluation updateFinalProjectEvaluation(FinalProjectEvaluation finalProjectEvaluation, Long id) {
        FinalProjectEvaluation existingEvaluation = finalProjectEvaluationRepository.findById(id).orElseThrow();
        if (finalProjectEvaluation.getSrs() != null) {
            existingEvaluation.setSrs(finalProjectEvaluation.getSrs());
        }
        if (finalProjectEvaluation.getWbs() != null) {
            existingEvaluation.setWbs(finalProjectEvaluation.getWbs());
        }
        if (finalProjectEvaluation.getDesignDocument() != null) {
            existingEvaluation.setDesignDocument(finalProjectEvaluation.getDesignDocument());
        }
        if (finalProjectEvaluation.getPpt() != null) {
            existingEvaluation.setPpt(finalProjectEvaluation.getPpt());
        }
        if (finalProjectEvaluation.getEvaluatorId() != null) {
            existingEvaluation.setEvaluatorId(finalProjectEvaluation.getEvaluatorId());
        }
        if (finalProjectEvaluation.getEvaluatedOn() != null) {
            existingEvaluation.setEvaluatedOn(finalProjectEvaluation.getEvaluatedOn());
        }
        if (finalProjectEvaluation.getObtainedMark() != null) {
            existingEvaluation.setTotalMark(finalProjectEvaluation.getObtainedMark());
        }
        if (finalProjectEvaluation.getRequirementUnderstanding() != null) {
            existingEvaluation.setRequirementUnderstanding(finalProjectEvaluation.getRequirementUnderstanding());
        }
        if (finalProjectEvaluation.getExpectedOutput() != null) {
            existingEvaluation.setExpectedOutput(finalProjectEvaluation.getExpectedOutput());
        }
        if (finalProjectEvaluation.getCodeQuality() != null) {
            existingEvaluation.setCodeQuality(finalProjectEvaluation.getCodeQuality());
        }
        if (finalProjectEvaluation.getDemonstrationOrPresentation() != null) {
            existingEvaluation.setDemonstrationOrPresentation(finalProjectEvaluation.getDemonstrationOrPresentation());
        }
        if (finalProjectEvaluation.getLiveCodingOrCodeUnderstanding() != null) {
            existingEvaluation.setLiveCodingOrCodeUnderstanding(finalProjectEvaluation.getLiveCodingOrCodeUnderstanding());
        }
        try {
            return finalProjectEvaluationRepository.save(existingEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Retrieves a list of task evaluations by the given batch ID, task type, and optional date.
     *
     * @param batchId  The ID of the batch.
     * @param taskType The type of the task.
     * @param date     Optional date to filter the evaluations. Can be null.
     * @return A list of TaskEvaluation objects associated with the batch ID, task type, and date (if provided).
     * @throws DatabaseException If there is an error fetching the evaluation information from the database.
     */
    @Transactional(readOnly = true)
    public List<TaskEvaluation> getEvaluationByBatchIdAndTaskType(Long batchId, TaskTypes taskType, String date) {
        try {
            if (date != null) {
                return taskEvaluationRepository.findAllByBatchIdAndEvaluationTypeAndEvaluatedOn(batchId, taskType.name(), date);
            }
            return taskEvaluationRepository.findAllByBatchIdAndEvaluationType(batchId, taskType.name());
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Retrieves a list of task evaluations by the given batch ID and optional date.
     *
     * @param batchId The ID of the batch.
     * @return A list of FinalProjectEvaluation objects associated with the batch ID
     * @throws DatabaseException If there is an error fetching the evaluation information from the database.
     */
    @Transactional(readOnly = true)
    public List<FinalProjectEvaluation> getFinalProjectEvaluation(Long batchId) {
        try {
            return finalProjectEvaluationRepository.findAllByBatchId(batchId);
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Saves a manager evaluation to the database.
     *
     * @param managerEvaluation The ManagerEvaluation object to be saved.
     * @return The saved ManagerEvaluation object.
     * @throws DatabaseException If there is an error saving the manager evaluation in the database.
     */
    @Transactional
    public ManagerEvaluation saveManagerEvaluation(ManagerEvaluation managerEvaluation) {
        managerEvaluation.setTotalMark(85.0);
        try {
            return managerEvaluationRepository.save(managerEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Updates a manager evaluation in the database with the provided evaluation data.
     *
     * @param managerEvaluation The ManagerEvaluation object containing the updated evaluation data.
     * @param id                The ID of the manager evaluation to be updated.
     * @return The updated ManagerEvaluation object.
     * @throws DatabaseException      If there is an error updating the manager evaluation in the database.
     * @throws NoSuchElementException If no  entry is found.
     */
    @Transactional
    public ManagerEvaluation updateManagerEvaluation(ManagerEvaluation managerEvaluation, Long id) {
        ManagerEvaluation existingEvaluation = managerEvaluationRepository.findById(id).orElseThrow();
        // Update the non-null values from managerEvaluation to existingEvaluation
        if (managerEvaluation.getTraineeId() != null) {
            existingEvaluation.setTraineeId(managerEvaluation.getTraineeId());
        }
        if (managerEvaluation.getBatchId() != null) {
            existingEvaluation.setBatchId(managerEvaluation.getBatchId());
        }
        if (managerEvaluation.getBjitTools() != null) {
            existingEvaluation.setBjitTools(managerEvaluation.getBjitTools());
        }
        if (managerEvaluation.getOfficeRules() != null) {
            existingEvaluation.setOfficeRules(managerEvaluation.getOfficeRules());
        }
        if (managerEvaluation.getSincerity() != null) {
            existingEvaluation.setSincerity(managerEvaluation.getSincerity());
        }
        if (managerEvaluation.getQuality() != null) {
            existingEvaluation.setQuality(managerEvaluation.getQuality());
        }
        if (managerEvaluation.getAttendance() != null) {
            existingEvaluation.setAttendance(managerEvaluation.getAttendance());
        }
        if (managerEvaluation.getCommunicationSkill() != null) {
            existingEvaluation.setCommunicationSkill(managerEvaluation.getCommunicationSkill());
        }
        if (managerEvaluation.getEnglishLanguageSkill() != null) {
            existingEvaluation.setEnglishLanguageSkill(managerEvaluation.getEnglishLanguageSkill());
        }
        if (managerEvaluation.getObtainedMark() != null) {
            existingEvaluation.setObtainedMark(managerEvaluation.getObtainedMark());
        }
        try {
            return managerEvaluationRepository.save(existingEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Retrieves a list of ManagerEvaluation objects based on the provided batch ID.
     *
     * @param batchId The ID of the batch.
     * @return A list of ManagerEvaluation objects associated with the batch.
     * @throws DatabaseException If there is an error retrieving the manager evaluations from the database.
     */
    @Transactional(readOnly = true)
    public List<ManagerEvaluation> getManagersEvaluation(Long batchId) {
        try {
            return managerEvaluationRepository.findAllByBatchId(batchId);
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Saves an aptitude and HR evaluation to the database.
     *
     * @param aptitudeAndHrEvaluation The AptitudeAndHrEvaluation object to be saved.
     * @return The saved AptitudeAndHrEvaluation object.
     * @throws DatabaseException If there is an error saving the aptitude and HR evaluation in the database.
     */
    @Transactional
    public AptitudeAndHrEvaluation saveAptitudeAndHrEvaluation(AptitudeAndHrEvaluation aptitudeAndHrEvaluation) {
        aptitudeAndHrEvaluation.setTotalMark(100.0);
        try {
            return aptitudeAndHrEvaluationRepository.save(aptitudeAndHrEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Updates an aptitude and HR evaluation in the database with the provided evaluation data.
     *
     * @param aptitudeAndHrEvaluation The AptitudeAndHrEvaluation object containing the updated evaluation data.
     * @param id                      The ID of the aptitude and HR evaluation to be updated.
     * @return The updated AptitudeAndHrEvaluation object.
     * @throws DatabaseException If there is an error updating the aptitude and HR evaluation in the database.
     */
    @Transactional
    public AptitudeAndHrEvaluation updateAptitudeAndHrEvaluation(AptitudeAndHrEvaluation aptitudeAndHrEvaluation, Long id) {
        AptitudeAndHrEvaluation existingEvaluation = aptitudeAndHrEvaluationRepository.findById(id).orElseThrow();
        // Update the non-null values from aptitudeAndHrEvaluation to existingEvaluation
        if (aptitudeAndHrEvaluation.getTraineeId() != null) {
            existingEvaluation.setTraineeId(aptitudeAndHrEvaluation.getTraineeId());
        }
        if (aptitudeAndHrEvaluation.getHrInterviewMark() != null) {
            existingEvaluation.setHrInterviewMark(aptitudeAndHrEvaluation.getHrInterviewMark());
        }
        if (aptitudeAndHrEvaluation.getObtainedMark() != null) {
            existingEvaluation.setObtainedMark(aptitudeAndHrEvaluation.getObtainedMark());
        }
        try {
            return aptitudeAndHrEvaluationRepository.save(existingEvaluation);
        } catch (Exception e) {
            throw new DatabaseException(EVALUATION_UPLOAD_FAILURE);
        }
    }
    /**
     * Retrieves a list of AptitudeAndHrEvaluation objects based on the provided batch ID.
     *
     * @param batchId The ID of the batch.
     * @return A list of AptitudeAndHrEvaluation objects associated with the batch.
     * @throws DatabaseException If there is an error retrieving the aptitude and HR evaluations from the database.
     */
    @Transactional(readOnly = true)
    public List<AptitudeAndHrEvaluation> getAptitudeAndHrEvaluation(Long batchId) {
        try {
            return aptitudeAndHrEvaluationRepository.findAllByBatchId(batchId);
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
}
