package com.bjitacademy.sajal48.ems.domian.evaluation;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.task.TaskTypes;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
class EvaluationServiceTest {
    @Mock
    private TaskEvaluationRepository taskEvaluationRepository;
    @Mock
    private FinalProjectEvaluationRepository finalProjectEvaluationRepository;
    @Mock
    private ManagerEvaluationRepository managerEvaluationRepository;
    @Mock
    private AptitudeAndHrEvaluationRepository aptitudeAndHrEvaluationRepository;
    @InjectMocks
    private EvaluationService evaluationService;
    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    @Test
    void saveTaskEvaluation_DailyTaskType_SetsTotalMarkAs10() {
        // Arrange
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        TaskTypes taskType = TaskTypes.DAILY_TASK;
        // Act
        evaluationService.saveTaskEvaluation(taskEvaluation, taskType);
        // Assert
        assertEquals(10.0, taskEvaluation.getTotalMark());
    }
    @Test
    void saveTaskEvaluation_MiniProjectType_SetsTotalMarkAs50() {
        // Arrange
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        TaskTypes taskType = TaskTypes.MINI_PROJECT;
        // Act
        evaluationService.saveTaskEvaluation(taskEvaluation, taskType);
        // Assert
        assertEquals(50.0, taskEvaluation.getTotalMark());
    }
    @Test
    void saveTaskEvaluation_MidProjectType_SetsTotalMarkAs100() {
        // Arrange
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        TaskTypes taskType = TaskTypes.MID_PROJECT;
        // Act
        evaluationService.saveTaskEvaluation(taskEvaluation, taskType);
        // Assert
        assertEquals(100.0, taskEvaluation.getTotalMark());
    }
    @Test
    void saveTaskEvaluation_TaskEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        TaskTypes taskType = TaskTypes.DAILY_TASK;
        when(taskEvaluationRepository.save(any(TaskEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.saveTaskEvaluation(taskEvaluation, taskType));
    }
    @Test
    void saveFinalProjectEvaluation_SetsTotalMarkAs100() {
        // Arrange
        FinalProjectEvaluation finalProjectEvaluation = new FinalProjectEvaluation();
        // Act
        evaluationService.saveFinalProjectEvaluation(finalProjectEvaluation);
        // Assert
        assertEquals(100.0, finalProjectEvaluation.getTotalMark());
    }
    @Test
    void saveFinalProjectEvaluation_FinalProjectEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        FinalProjectEvaluation finalProjectEvaluation = new FinalProjectEvaluation();
        when(finalProjectEvaluationRepository.save(any(FinalProjectEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.saveFinalProjectEvaluation(finalProjectEvaluation));
    }
    @Test
    void updateTaskEvaluation_UpdatesTaskEvaluationInDatabase() {
        // Arrange
        Long taskId = 1L;
        TaskEvaluation existingTaskEvaluation = new TaskEvaluation();
        existingTaskEvaluation.setId(taskId);
        existingTaskEvaluation.setObtainedMark(80.0);
        TaskEvaluation updatedTaskEvaluation = new TaskEvaluation();
        updatedTaskEvaluation.setId(taskId);
        updatedTaskEvaluation.setObtainedMark(90.0);
        updatedTaskEvaluation.setRequirementUnderstanding(5.0);
        when(taskEvaluationRepository.findById(taskId)).thenReturn(java.util.Optional.of(existingTaskEvaluation));
        when(taskEvaluationRepository.save(any(TaskEvaluation.class))).thenReturn(updatedTaskEvaluation);
        // Act
        TaskEvaluation result = evaluationService.updateTaskEvaluation(updatedTaskEvaluation, taskId);
        // Assert
        assertNotNull(result);
        assertEquals(taskId, result.getId());
        assertEquals(90.0, result.getObtainedMark());
        assertEquals(5.0, result.getRequirementUnderstanding());
    }
    @Test
    void updateTaskEvaluation_TaskEvaluationNotFoundInDatabase_ThrowsNoSuchElementException() {
        // Arrange
        Long taskId = 1L;
        TaskEvaluation updatedTaskEvaluation = new TaskEvaluation();
        updatedTaskEvaluation.setId(taskId);
        when(taskEvaluationRepository.findById(taskId)).thenReturn(java.util.Optional.empty());
        // Act & Assert
        assertThrows(java.util.NoSuchElementException.class, () -> evaluationService.updateTaskEvaluation(updatedTaskEvaluation, taskId));
    }
    @Test
    void updateTaskEvaluation_TaskEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long taskId = 1L;
        TaskEvaluation existingTaskEvaluation = new TaskEvaluation();
        existingTaskEvaluation.setId(taskId);
        when(taskEvaluationRepository.findById(taskId)).thenReturn(java.util.Optional.of(existingTaskEvaluation));
        when(taskEvaluationRepository.save(any(TaskEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.updateTaskEvaluation(existingTaskEvaluation, taskId));
    }
    @Test
    void updateFinalProjectEvaluation_UpdatesFinalProjectEvaluationInDatabase() {
        // Arrange
        Long evaluationId = 1L;
        FinalProjectEvaluation existingEvaluation = new FinalProjectEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setSrs(10.0);
        existingEvaluation.setPpt(10.0);
        FinalProjectEvaluation updatedEvaluation = new FinalProjectEvaluation();
        updatedEvaluation.setId(evaluationId);
        updatedEvaluation.setBatchId(300L);
        updatedEvaluation.setTraineeId(400L);
        updatedEvaluation.setEvaluatorId(200L);
        updatedEvaluation.setEvaluatedOn("2022-06-05");
        updatedEvaluation.setObtainedMark(100.0);
        updatedEvaluation.setRequirementUnderstanding(10.0);
        updatedEvaluation.setExpectedOutput(10.0);
        updatedEvaluation.setDemonstrationOrPresentation(10.0);
        updatedEvaluation.setLiveCodingOrCodeUnderstanding(10.0);
        updatedEvaluation.setSrs(15.0);
        updatedEvaluation.setPpt(15.0);
        updatedEvaluation.setCodeQuality(10.0);
        when(finalProjectEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(finalProjectEvaluationRepository.save(any(FinalProjectEvaluation.class))).thenReturn(updatedEvaluation);
        // Act
        FinalProjectEvaluation result = evaluationService.updateFinalProjectEvaluation(updatedEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(15.0, result.getSrs());
        assertEquals(15.0, result.getPpt());
        assertEquals(10.0, result.getCodeQuality());
    }
    @Test
    void updateFinalProjectEvaluation_FinalProjectEvaluationNotFoundInDatabase_ThrowsNoSuchElementException() {
        // Arrange
        Long evaluationId = 1L;
        FinalProjectEvaluation updatedEvaluation = new FinalProjectEvaluation();
        updatedEvaluation.setId(evaluationId);
        when(finalProjectEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.empty());
        // Act & Assert
        assertThrows(java.util.NoSuchElementException.class, () -> evaluationService.updateFinalProjectEvaluation(updatedEvaluation, evaluationId));
    }
    @Test
    void updateFinalProjectEvaluation_FinalProjectEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long evaluationId = 1L;
        FinalProjectEvaluation existingEvaluation = new FinalProjectEvaluation();
        existingEvaluation.setId(evaluationId);
        when(finalProjectEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(finalProjectEvaluationRepository.save(any(FinalProjectEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.updateFinalProjectEvaluation(existingEvaluation, evaluationId));
    }
    @Test
    void getEvaluationByBatchIdAndTaskType_DateProvided_ReturnsTaskEvaluationList() {
        // Arrange
        Long batchId = 1L;
        TaskTypes taskType = TaskTypes.MINI_PROJECT;
        String date = "2023/07/22";
        List<TaskEvaluation> taskEvaluations = Arrays.asList(new TaskEvaluation(), new TaskEvaluation());
        when(taskEvaluationRepository.findAllByBatchIdAndEvaluationTypeAndEvaluatedOn(batchId, taskType.name(), date)).thenReturn(taskEvaluations);
        // Act
        List<TaskEvaluation> result = evaluationService.getEvaluationByBatchIdAndTaskType(batchId, taskType, date);
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void getEvaluationByBatchIdAndTaskType_DateNotProvided_ReturnsTaskEvaluationList() {
        // Arrange
        Long batchId = 1L;
        TaskTypes taskType = TaskTypes.MINI_PROJECT;
        List<TaskEvaluation> taskEvaluations = Arrays.asList(new TaskEvaluation(), new TaskEvaluation());
        when(taskEvaluationRepository.findAllByBatchIdAndEvaluationType(batchId, taskType.name())).thenReturn(taskEvaluations);
        // Act
        List<TaskEvaluation> result = evaluationService.getEvaluationByBatchIdAndTaskType(batchId, taskType, null);
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void getEvaluationByBatchIdAndTaskType_TaskEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long batchId = 1L;
        TaskTypes taskType = TaskTypes.MINI_PROJECT;
        String date = "2023/07/22";
        when(taskEvaluationRepository.findAllByBatchIdAndEvaluationTypeAndEvaluatedOn(batchId, taskType.name(), date))
                .thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.getEvaluationByBatchIdAndTaskType(batchId, taskType, date));
    }
    @Test
    void getFinalProjectEvaluation_ReturnsFinalProjectEvaluationList() {
        // Arrange
        Long batchId = 1L;
        List<FinalProjectEvaluation> finalProjectEvaluations = Arrays.asList(new FinalProjectEvaluation(), new FinalProjectEvaluation());
        when(finalProjectEvaluationRepository.findAllByBatchId(batchId)).thenReturn(finalProjectEvaluations);
        // Act
        List<FinalProjectEvaluation> result = evaluationService.getFinalProjectEvaluation(batchId);
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void getFinalProjectEvaluation_FinalProjectEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long batchId = 1L;
        when(finalProjectEvaluationRepository.findAllByBatchId(batchId)).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.getFinalProjectEvaluation(batchId));
    }
    @Test
    void saveManagerEvaluation_SetsTotalMarkAs85() {
        // Arrange
        ManagerEvaluation managerEvaluation = new ManagerEvaluation();
        // Act
        evaluationService.saveManagerEvaluation(managerEvaluation);
        // Assert
        assertEquals(85.0, managerEvaluation.getTotalMark());
    }
    @Test
    void saveManagerEvaluation_ManagerEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        ManagerEvaluation managerEvaluation = new ManagerEvaluation();
        when(managerEvaluationRepository.save(any(ManagerEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.saveManagerEvaluation(managerEvaluation));
    }
    @Test
    void updateManagerEvaluation_UpdatesManagerEvaluationInDatabase() {
        // Arrange
        Long evaluationId = 1L;
        ManagerEvaluation existingEvaluation = new ManagerEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setTraineeId(100L);
        existingEvaluation.setQuality(5.0);
        ManagerEvaluation updatedEvaluation = new ManagerEvaluation();
        updatedEvaluation.setId(existingEvaluation.getId());
        updatedEvaluation.setTraineeId(existingEvaluation.getTraineeId());
        updatedEvaluation.setBatchId(1000L);
        updatedEvaluation.setBjitTools(10.0);
        updatedEvaluation.setOfficeRules(12.0);
        updatedEvaluation.setSincerity(20.0);
        updatedEvaluation.setAttendance(100.0);
        updatedEvaluation.setCommunicationSkill(10.0);
        updatedEvaluation.setEnglishLanguageSkill(10.0);
        updatedEvaluation.setObtainedMark(100.0);
        updatedEvaluation.setQuality(10.0);
        when(managerEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(managerEvaluationRepository.save(any(ManagerEvaluation.class))).thenReturn(updatedEvaluation);
        // Act
        ManagerEvaluation result = evaluationService.updateManagerEvaluation(updatedEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(100L, result.getTraineeId());
        assertEquals(10.0, result.getQuality());
    }
    @Test
    void updateManagerEvaluation_ManagerEvaluationNotFoundInDatabase_ThrowsNoSuchElementException() {
        // Arrange
        Long evaluationId = 1L;
        ManagerEvaluation updatedEvaluation = new ManagerEvaluation();
        updatedEvaluation.setId(evaluationId);
        when(managerEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.empty());
        // Act & Assert
        assertThrows(java.util.NoSuchElementException.class, () -> evaluationService.updateManagerEvaluation(updatedEvaluation, evaluationId));
    }
    @Test
    void updateManagerEvaluation_ManagerEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long evaluationId = 1L;
        ManagerEvaluation existingEvaluation = new ManagerEvaluation();
        existingEvaluation.setId(evaluationId);
        when(managerEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(managerEvaluationRepository.save(any(ManagerEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.updateManagerEvaluation(existingEvaluation, evaluationId));
    }
    @Test
    void getManagersEvaluation_ReturnsManagerEvaluationList() {
        // Arrange
        Long batchId = 1L;
        List<ManagerEvaluation> managerEvaluations = Arrays.asList(new ManagerEvaluation(), new ManagerEvaluation());
        when(managerEvaluationRepository.findAllByBatchId(batchId)).thenReturn(managerEvaluations);
        // Act
        List<ManagerEvaluation> result = evaluationService.getManagersEvaluation(batchId);
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void getManagersEvaluation_ManagerEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long batchId = 1L;
        when(managerEvaluationRepository.findAllByBatchId(batchId)).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.getManagersEvaluation(batchId));
    }
    @Test
    void saveAptitudeAndHrEvaluation_SetsTotalMarkAs100() {
        // Arrange
        AptitudeAndHrEvaluation aptitudeAndHrEvaluation = new AptitudeAndHrEvaluation();
        // Act
        evaluationService.saveAptitudeAndHrEvaluation(aptitudeAndHrEvaluation);
        // Assert
        assertEquals(100.0, aptitudeAndHrEvaluation.getTotalMark());
    }
    @Test
    void saveAptitudeAndHrEvaluation_AptitudeAndHrEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        AptitudeAndHrEvaluation aptitudeAndHrEvaluation = new AptitudeAndHrEvaluation();
        when(aptitudeAndHrEvaluationRepository.save(any(AptitudeAndHrEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.saveAptitudeAndHrEvaluation(aptitudeAndHrEvaluation));
    }
    @Test
    void updateAptitudeAndHrEvaluation_AptitudeAndHrEvaluationNotFoundInDatabase_ThrowsNoSuchElementException() {
        // Arrange
        Long evaluationId = 1L;
        AptitudeAndHrEvaluation updatedEvaluation = new AptitudeAndHrEvaluation();
        updatedEvaluation.setId(evaluationId);
        updatedEvaluation.setBatchId(100L);
        when(aptitudeAndHrEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.empty());
        // Act & Assert
        assertThrows(java.util.NoSuchElementException.class, () -> evaluationService.updateAptitudeAndHrEvaluation(updatedEvaluation, evaluationId));
    }
    @Test
    void updateAptitudeAndHrEvaluation_AptitudeAndHrEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long evaluationId = 1L;
        AptitudeAndHrEvaluation existingEvaluation = new AptitudeAndHrEvaluation();
        existingEvaluation.setId(evaluationId);
        when(aptitudeAndHrEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(aptitudeAndHrEvaluationRepository.save(any(AptitudeAndHrEvaluation.class))).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.updateAptitudeAndHrEvaluation(existingEvaluation, evaluationId));
    }
    @Test
    void getAptitudeAndHrEvaluation_ReturnsAptitudeAndHrEvaluationList() {
        // Arrange
        Long batchId = 1L;
        List<AptitudeAndHrEvaluation> aptitudeAndHrEvaluations = Arrays.asList(new AptitudeAndHrEvaluation(), new AptitudeAndHrEvaluation());
        when(aptitudeAndHrEvaluationRepository.findAllByBatchId(batchId)).thenReturn(aptitudeAndHrEvaluations);
        // Act
        List<AptitudeAndHrEvaluation> result = evaluationService.getAptitudeAndHrEvaluation(batchId);
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void getAptitudeAndHrEvaluation_AptitudeAndHrEvaluationRepositoryThrowsException_ThrowsDatabaseException() {
        // Arrange
        Long batchId = 1L;
        when(aptitudeAndHrEvaluationRepository.findAllByBatchId(batchId)).thenThrow(new RuntimeException("Database error"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> evaluationService.getAptitudeAndHrEvaluation(batchId));
    }
    @Test
    void updateTaskEvaluation_PartialUpdatesExistingTaskEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        TaskEvaluation existingEvaluation = new TaskEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setExpectedOutput(80.0);
        existingEvaluation.setCodeQuality(70.0);
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        taskEvaluation.setCodeQuality(85.0);
        when(taskEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(taskEvaluationRepository.save(any(TaskEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        TaskEvaluation result = evaluationService.updateTaskEvaluation(taskEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(80, result.getExpectedOutput());
        assertEquals(85, result.getCodeQuality());
        assertNull(result.getDemonstrationOrPresentation());
        assertNull(result.getLiveCodingOrCodeUnderstanding());
    }
    @Test
    void updateTaskEvaluation_AllFieldsUpdatesExistingTaskEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        TaskEvaluation existingEvaluation = new TaskEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setExpectedOutput(80.0);
        existingEvaluation.setCodeQuality(70.0);
        TaskEvaluation taskEvaluation = new TaskEvaluation();
        taskEvaluation.setExpectedOutput(85.0);
        taskEvaluation.setCodeQuality(90.0);
        taskEvaluation.setDemonstrationOrPresentation(75.0);
        taskEvaluation.setLiveCodingOrCodeUnderstanding(88.0);
        when(taskEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(taskEvaluationRepository.save(any(TaskEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        TaskEvaluation result = evaluationService.updateTaskEvaluation(taskEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(85.0, result.getExpectedOutput());
        assertEquals(90.0, result.getCodeQuality());
        assertEquals(75.0, result.getDemonstrationOrPresentation());
        assertEquals(88.0, result.getLiveCodingOrCodeUnderstanding());
    }
    @Test
    void updateFinalProjectEvaluation_PartialUpdatesExistingFinalProjectEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        FinalProjectEvaluation existingEvaluation = new FinalProjectEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setSrs(90.0);
        existingEvaluation.setDesignDocument(80.0);
        FinalProjectEvaluation finalProjectEvaluation = new FinalProjectEvaluation();
        finalProjectEvaluation.setSrs(95.0);
        when(finalProjectEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(finalProjectEvaluationRepository.save(any(FinalProjectEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        FinalProjectEvaluation result = evaluationService.updateFinalProjectEvaluation(finalProjectEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(95.0, result.getSrs());
        assertEquals(80.0, result.getDesignDocument());
        assertNull(result.getWbs());
        assertNull(result.getPpt());
    }
    @Test
    void updateFinalProjectEvaluation_AllFieldsUpdatesExistingFinalProjectEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        FinalProjectEvaluation existingEvaluation = new FinalProjectEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setSrs(90.0);
        existingEvaluation.setDesignDocument(80.0);
        FinalProjectEvaluation finalProjectEvaluation = new FinalProjectEvaluation();
        finalProjectEvaluation.setSrs(95.0);
        finalProjectEvaluation.setDesignDocument(88.0);
        finalProjectEvaluation.setWbs(85.0);
        finalProjectEvaluation.setPpt(70.0);
        when(finalProjectEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(finalProjectEvaluationRepository.save(any(FinalProjectEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        FinalProjectEvaluation result = evaluationService.updateFinalProjectEvaluation(finalProjectEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(95.0, result.getSrs());
        assertEquals(88.0, result.getDesignDocument());
        assertEquals(85.0, result.getWbs());
        assertEquals(70.0, result.getPpt());
    }
    @Test
    void updateAptitudeAndHrEvaluation_PartialUpdatesExistingAptitudeAndHrEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        AptitudeAndHrEvaluation existingEvaluation = new AptitudeAndHrEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setTraineeId(10L);
        existingEvaluation.setHrInterviewMark(90.0);
        AptitudeAndHrEvaluation aptitudeAndHrEvaluation = new AptitudeAndHrEvaluation();
        aptitudeAndHrEvaluation.setHrInterviewMark(95.0);
        when(aptitudeAndHrEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(aptitudeAndHrEvaluationRepository.save(any(AptitudeAndHrEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        AptitudeAndHrEvaluation result = evaluationService.updateAptitudeAndHrEvaluation(aptitudeAndHrEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(10L, result.getTraineeId());
        assertEquals(95.0, result.getHrInterviewMark());
        assertNull(result.getObtainedMark());
    }
    @Test
    void updateAptitudeAndHrEvaluation_AllFieldsUpdatesExistingAptitudeAndHrEvaluation() {
        // Arrange
        Long evaluationId = 1L;
        AptitudeAndHrEvaluation existingEvaluation = new AptitudeAndHrEvaluation();
        existingEvaluation.setId(evaluationId);
        existingEvaluation.setTraineeId(10L);
        existingEvaluation.setHrInterviewMark(90.0);
        AptitudeAndHrEvaluation aptitudeAndHrEvaluation = new AptitudeAndHrEvaluation();
        aptitudeAndHrEvaluation.setTraineeId(20L);
        aptitudeAndHrEvaluation.setHrInterviewMark(95.0);
        aptitudeAndHrEvaluation.setObtainedMark(90.0);
        when(aptitudeAndHrEvaluationRepository.findById(evaluationId)).thenReturn(java.util.Optional.of(existingEvaluation));
        when(aptitudeAndHrEvaluationRepository.save(any(AptitudeAndHrEvaluation.class))).thenReturn(existingEvaluation);
        // Act
        AptitudeAndHrEvaluation result = evaluationService.updateAptitudeAndHrEvaluation(aptitudeAndHrEvaluation, evaluationId);
        // Assert
        assertNotNull(result);
        assertEquals(evaluationId, result.getId());
        assertEquals(20L, result.getTraineeId());
        assertEquals(95.0, result.getHrInterviewMark());
        assertEquals(90.0, result.getObtainedMark());
    }
}