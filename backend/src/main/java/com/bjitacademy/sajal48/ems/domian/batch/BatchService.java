package com.bjitacademy.sajal48.ems.domian.batch;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserDetailsRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class BatchService {
    private final BatchRepository batchRepository;
    private final UserDetailsRepository userDetailsRepository;
    public BatchService(BatchRepository batchRepository, UserDetailsRepository userDetailsRepository) {
        this.batchRepository = batchRepository;
        this.userDetailsRepository = userDetailsRepository;
    }
    /**
     * Creates a new batch.
     *
     * @param batch the batch to create
     * @return the created batch
     * @throws DatabaseException if there is an error creating the batch
     */
    @Transactional
    public Batch createBatch(Batch batch) {
        batch.setStatus(true);
        try {
            return batchRepository.save(batch);
        } catch (Exception e) {
            throw new DatabaseException(BATCH_ADD_FAILURE);
        }
    }
    /**
     * Finds a batch by its ID.
     *
     * @param id the ID of the batch to find
     * @return the found batch
     * @throws DatabaseException if there is an error getting the batch information
     */
    @Transactional(readOnly = true)
    public Batch findBatch(Long id) {
        return batchRepository.findBatchById(id).orElseThrow();
    }
    /**
     * Gets the batch associated with the given user ID.
     *
     * @param userId the ID of the user
     * @return the batch associated with the user
     * @throws DatabaseException if there is an error getting the batch information
     */
    @Transactional(readOnly = true)
    public Batch getBatchByUserId(Long userId) {
        try {
            long batchId = batchRepository.findBatchByUserId(userId);
            return batchRepository.findBatchById(batchId).get();
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Updates a batch with the provided data.
     *
     * @param batch   the batch data to update
     * @param batchId the ID of the batch to update
     * @return the updated batch
     * @throws DatabaseException      if there is an error updating the batch information
     * @throws NoSuchElementException If no  entry is found.
     */
    @Transactional
    public Batch updateBatch(Batch batch, Long batchId, List<Long> userIds) {
        Batch currentInfo = batchRepository.findBatchById(batchId).orElseThrow();
        try {
            if (userIds != null) {
                for (Long userId : userIds) {
                    var user = userDetailsRepository.findByUserId(userId);
                    if (user.isPresent() && user.get().getRole().equals("TRAINEE")) {
                        if (batchRepository.countByUserId(userId) == 0) {
                            currentInfo.getTrainees().add(user.get());
                        }
                    }
                }
            }
            // Update the non-null values from the provided batch object
            if (batch.getBatchName() != null) {
                currentInfo.setBatchName(batch.getBatchName());
            }
            if (batch.getDescription() != null) {
                currentInfo.setDescription(batch.getDescription());
            }
            if (batch.getStartDate() != null) {
                currentInfo.setStartDate(batch.getStartDate());
            }
            if (batch.getEndDate() != null) {
                currentInfo.setEndDate(batch.getEndDate());
            }
            if (batch.getStatus() != null) {
                currentInfo.setStatus(batch.getStatus());
            }
            return batchRepository.save(currentInfo);
        } catch (Exception e) {
            throw new DatabaseException(BATCH_UPDATE_FAILURE);
        }
    }
    /**
     * Retrieves all batches.
     *
     * @return a list of all batches
     * @throws DatabaseException if there is an error retrieving the batch information
     */
    @Transactional(readOnly = true)
    public List<Batch> getAllBatches() {
        try {
            return batchRepository.findAll();
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Deletes a batch by its ID.
     *
     * @param id the ID of the batch to delete
     * @throws DatabaseException      if there is an error deleting the batch
     * @throws NoSuchElementException If no  entry is found.
     */
    @Transactional
    public void deleteBatch(Long id) {
        Batch batch = batchRepository.findBatchById(id).orElseThrow();
        try {
            batch.setTrainees(null);
            batchRepository.save(batch);
            batchRepository.delete(batch);
        } catch (Exception e) {
            throw new DatabaseException(BATCH_DELETE_FAILURE);
        }
    }
}
