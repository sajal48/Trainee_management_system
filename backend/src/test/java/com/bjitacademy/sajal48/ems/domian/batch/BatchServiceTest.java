package com.bjitacademy.sajal48.ems.domian.batch;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetails;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetailsRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
class BatchServiceTest {
    @Mock
    private BatchRepository batchRepository;
    @Mock
    private UserDetailsRepository userDetailsRepository;
    @InjectMocks
    private BatchService batchService;
    @BeforeEach
    void setUp() {
        MockitoAnnotations.initMocks(this);
    }
    @Test
    void createBatch_ValidBatch_ReturnsCreatedBatch() {
        // Arrange
        Batch batchToCreate = new Batch();
        batchToCreate.setBatchName("Test Batch");
        batchToCreate.setDescription("Test Description");
        batchToCreate.setStartDate("2023-07-01");
        batchToCreate.setEndDate("2023-12-31");
        batchToCreate.setStatus(true);
        when(batchRepository.save(any(Batch.class))).thenReturn(batchToCreate);
        // Act
        Batch createdBatch = batchService.createBatch(batchToCreate);
        // Assert
        assertNotNull(createdBatch);
        assertEquals("Test Batch", createdBatch.getBatchName());
        assertEquals("Test Description", createdBatch.getDescription());
        assertEquals("2023-07-01", createdBatch.getStartDate());
        assertEquals("2023-12-31", createdBatch.getEndDate());
        assertTrue(createdBatch.getStatus());
    }
    @Test
    void findBatch_ExistingBatchId_ReturnsFoundBatch() {
        // Arrange
        long existingBatchId = 1L;
        Batch foundBatch = new Batch();
        foundBatch.setId(existingBatchId);
        when(batchRepository.findBatchById(existingBatchId)).thenReturn(Optional.of(foundBatch));
        // Act
        Batch result = batchService.findBatch(existingBatchId);
        // Assert
        assertNotNull(result);
        assertEquals(existingBatchId, result.getId());
    }
    @Test
    void findBatch_NonExistingBatchId_ThrowsDatabaseException() {
        // Arrange
        long nonExistingBatchId = 100L;
        when(batchRepository.findBatchById(nonExistingBatchId)).thenReturn(Optional.empty());
        // Act & Assert
        assertThrows(NoSuchElementException.class, () -> batchService.findBatch(nonExistingBatchId));
    }
    @Test
    void getBatchByUserId_ExistingUserId_ReturnsBatchAssociatedWithUser() {
        // Arrange
        long userId = 1L;
        long associatedBatchId = 100L;
        Batch associatedBatch = new Batch();
        associatedBatch.setId(associatedBatchId);
        when(batchRepository.findBatchByUserId(userId)).thenReturn(associatedBatchId);
        when(batchRepository.findBatchById(associatedBatchId)).thenReturn(Optional.of(associatedBatch));
        // Act
        Batch result = batchService.getBatchByUserId(userId);
        // Assert
        assertNotNull(result);
        assertEquals(associatedBatchId, result.getId());
    }
    @Test
    void getBatchByUserId_NonExistingUserId_ThrowsDatabaseException() {
        // Arrange
        long nonExistingUserId = 200L;
        when(batchRepository.findBatchByUserId(nonExistingUserId)).thenReturn(0L);
        // Act & Assert
        assertThrows(DatabaseException.class, () -> batchService.getBatchByUserId(nonExistingUserId));
    }
    @Test
    void updateBatch_ValidBatchAndBatchId_ReturnsUpdatedBatch() {
        // Arrange
        long batchId = 1L;
        Batch existingBatch = new Batch();
        existingBatch.setId(batchId);
        existingBatch.setBatchName("Old Batch Name");
        existingBatch.setDescription("Old Description");
        existingBatch.setStartDate("2023-01-01");
        existingBatch.setEndDate("2023-06-30");
        existingBatch.setStatus(false);
        List<Long> userIds = new ArrayList<>();
        userIds.add(101L);
        UserDetails user = new UserDetails();
        user.setUserId(101L);
        user.setRole("TRAINEE");
        when(batchRepository.findBatchById(batchId)).thenReturn(Optional.of(existingBatch));
        when(userDetailsRepository.findByUserId(101L)).thenReturn(Optional.of(user));
        when(batchRepository.countByUserId(101L)).thenReturn(0L);
        when(batchRepository.save(any(Batch.class))).thenAnswer(invocation -> invocation.getArgument(0));
        // Act
        Batch updatedBatch = batchService.updateBatch(
                Batch.builder()
                        .batchName("Updated Batch Name")
                        .description("Updated Description")
                        .startDate("2023-02-01")
                        .endDate("2023-07-31")
                        .status(true)
                        .build(),
                batchId,
                userIds
        );
        // Assert
        assertNotNull(updatedBatch);
        assertEquals(batchId, updatedBatch.getId());
        assertEquals("Updated Batch Name", updatedBatch.getBatchName());
        assertEquals("Updated Description", updatedBatch.getDescription());
        assertEquals("2023-02-01", updatedBatch.getStartDate());
        assertEquals("2023-07-31", updatedBatch.getEndDate());
        assertTrue(updatedBatch.getStatus());
        assertTrue(updatedBatch.getTrainees().contains(user));
    }
    @Test
    void updateBatch_NonExistingBatchId_ThrowsNoSuchElementException() {
        // Arrange
        long nonExistingBatchId = 200L;
        List<Long> userIds = new ArrayList<>();
        userIds.add(101L);
        when(batchRepository.findBatchById(nonExistingBatchId)).thenReturn(Optional.empty());
        // Act & Assert
        assertThrows(NoSuchElementException.class, () -> batchService.updateBatch(
                Batch.builder()
                        .batchName("Updated Batch Name")
                        .description("Updated Description")
                        .startDate("2023-02-01")
                        .endDate("2023-07-31")
                        .status(true)
                        .build(),
                nonExistingBatchId,
                userIds
        ));
    }
    @Test
    void getAllBatches_ReturnsListOfBatches() {
        // Arrange
        List<Batch> batches = new ArrayList<>();
        batches.add(new Batch());
        batches.add(new Batch());
        when(batchRepository.findAll()).thenReturn(batches);
        // Act
        List<Batch> result = batchService.getAllBatches();
        // Assert
        assertNotNull(result);
        assertEquals(2, result.size());
    }
    @Test
    void deleteBatch_ExistingBatchId_DeletesBatch() {
        // Arrange
        long existingBatchId = 1L;
        Batch existingBatch = new Batch();
        existingBatch.setId(existingBatchId);
        when(batchRepository.findBatchById(existingBatchId)).thenReturn(Optional.of(existingBatch));
        // Act
        batchService.deleteBatch(existingBatchId);
        // Assert
        verify(batchRepository, times(1)).save(existingBatch);
        verify(batchRepository, times(1)).delete(existingBatch);
        assertNull(existingBatch.getTrainees());
    }
    @Test
    void deleteBatch_NonExistingBatchId_ThrowsNoSuchElementException() {
        // Arrange
        long nonExistingBatchId = 200L;
        when(batchRepository.findBatchById(nonExistingBatchId)).thenReturn(Optional.empty());
        // Act & Assert
        assertThrows(NoSuchElementException.class, () -> batchService.deleteBatch(nonExistingBatchId));
    }
    @Test
    void createBatch_ExceptionDuringSaving_ThrowsDatabaseException() {
        // Arrange
        Batch batchToCreate = new Batch();
        batchToCreate.setBatchName("Test Batch");
        batchToCreate.setDescription("Test Description");
        batchToCreate.setStartDate("2023-07-01");
        batchToCreate.setEndDate("2023-12-31");
        batchToCreate.setStatus(true);
        when(batchRepository.save(any(Batch.class))).thenThrow(new RuntimeException("Error saving batch"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> batchService.createBatch(batchToCreate));
    }
    @Test
    void getAllBatches_ExceptionDuringRetrieval_ThrowsDatabaseException() {
        // Arrange
        when(batchRepository.findAll()).thenThrow(new RuntimeException("Error retrieving batches"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> batchService.getAllBatches());
    }
    @Test
    void deleteBatch_ValidBatchId_DeletesBatchAndRemovesTrainees() {
        // Arrange
        long existingBatchId = 1L;
        Batch existingBatch = new Batch();
        existingBatch.setId(existingBatchId);
        when(batchRepository.findBatchById(existingBatchId)).thenReturn(Optional.of(existingBatch));
        // Act
        batchService.deleteBatch(existingBatchId);
        // Assert
        verify(batchRepository, times(1)).delete(existingBatch);
        assertNull(existingBatch.getTrainees());
    }
    @Test
    void deleteBatch_DeletingBatchWithTrainees_SetsTraineesToNull() {
        // Arrange
        long existingBatchId = 1L;
        Batch existingBatch = new Batch();
        existingBatch.setId(existingBatchId);
        Set<UserDetails> trainees = new HashSet<>();
        trainees.add(new UserDetails());
        trainees.add(new UserDetails());
        existingBatch.setTrainees(trainees);
        when(batchRepository.findBatchById(existingBatchId)).thenReturn(Optional.of(existingBatch));
        // Act
        batchService.deleteBatch(existingBatchId);
        // Assert
        verify(batchRepository, times(1)).save(existingBatch);
        verify(batchRepository, times(1)).delete(existingBatch);
        assertNull(existingBatch.getTrainees());
    }
    @Test
    void deleteBatch_ExceptionDuringDeletion_ThrowsDatabaseException() {
        // Arrange
        long existingBatchId = 1L;
        Batch existingBatch = new Batch();
        existingBatch.setId(existingBatchId);
        when(batchRepository.findBatchById(existingBatchId)).thenReturn(Optional.of(existingBatch));
        doThrow(new RuntimeException("Error deleting batch")).when(batchRepository).delete(existingBatch);
        // Act & Assert
        assertThrows(DatabaseException.class, () -> batchService.deleteBatch(existingBatchId));
    }
    @Test
    void updateBatch_ExceptionDuringUpdate_ThrowsDatabaseException() {
        // Arrange
        long batchId = 1L;
        List<Long> userIds = new ArrayList<>();
        userIds.add(101L);
        Batch existingBatch = new Batch();
        existingBatch.setId(batchId);
        when(batchRepository.findBatchById(batchId)).thenReturn(Optional.of(existingBatch));
        when(userDetailsRepository.findByUserId(101L)).thenReturn(Optional.of(new UserDetails()));
        when(batchRepository.countByUserId(101L)).thenReturn(0L);
        when(batchRepository.save(any(Batch.class))).thenThrow(new RuntimeException("Error updating batch"));
        // Act & Assert
        assertThrows(DatabaseException.class, () -> batchService.updateBatch(
                Batch.builder()
                        .batchName("Updated Batch Name")
                        .description("Updated Description")
                        .startDate("2023-02-01")
                        .endDate("2023-07-31")
                        .status(true)
                        .build(),
                batchId,
                userIds
        ));
    }
}
