package com.bjitacademy.sajal48.ems.domian.evaluation;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class WeightageService {
    private final WeightageRepository weightageRepository;
    public WeightageService(WeightageRepository weightageRepository) {
        this.weightageRepository = weightageRepository;
    }
    /**
     * Retrieves the weightage entry.
     *
     * @return The weightage entry.
     * @throws NoSuchElementException If no weightage entry is found.
     */
    @Transactional(readOnly = true)
    @Cacheable(value = "Weightage")
    public Weightage getWeightage() {
        List<Weightage> weightages = weightageRepository.findAll();
        if (!weightages.isEmpty()) {
            return weightages.get(0);
        } else {
            throw new NoSuchElementException(WEIGHTAGE_NOT_FOUND);
        }
    }
    /**
     * Updates the weightage entry with the provided weightage values.
     * Only non-null values from the provided weightage object are updated.
     *
     * @param weightage The weightage object containing the updated weightage values.
     * @return The updated weightage entry.
     * @throws DatabaseException If there is an error updating the weightage entry in the database.
     */
    @Transactional
    @CacheEvict(value = "Weightage", allEntries = true)
    public Weightage updateWeightage(Weightage weightage) {
        Weightage existingWeightage = getWeightage();
        if (weightage.getDailyTaskEvaluationWeightage() != null) {
            existingWeightage.setDailyTaskEvaluationWeightage(weightage.getDailyTaskEvaluationWeightage());
        }
        if (weightage.getMiniProjectEvaluationWeightage() != null) {
            existingWeightage.setMiniProjectEvaluationWeightage(weightage.getMiniProjectEvaluationWeightage());
        }
        if (weightage.getMidProjectEvaluationWeightage() != null) {
            existingWeightage.setMidProjectEvaluationWeightage(weightage.getMidProjectEvaluationWeightage());
        }
        if (weightage.getFinalProjectEvaluationWeightage() != null) {
            existingWeightage.setFinalProjectEvaluationWeightage(weightage.getFinalProjectEvaluationWeightage());
        }
        if (weightage.getManagerEvaluationWeightage() != null) {
            existingWeightage.setManagerEvaluationWeightage(weightage.getManagerEvaluationWeightage());
        }
        if (weightage.getDomainWeightage() != null) {
            existingWeightage.setDomainWeightage(weightage.getDomainWeightage());
        }
        if (weightage.getTrainingWeightage() != null) {
            existingWeightage.setTrainingWeightage(weightage.getTrainingWeightage());
        }
        if (weightage.getHrInterviewEvaluationWeightage() != null) {
            existingWeightage.setHrInterviewEvaluationWeightage(weightage.getHrInterviewEvaluationWeightage());
        }
        try {
            return weightageRepository.save(existingWeightage);
        } catch (Exception e) {
            throw new DatabaseException(WEIGHTAGE_UPDATE_FAILURE);
        }
    }
    /**
     * Initializes the weightage with default values.
     * The values are specified as percentages:
     * - Daily Task Evaluation Weightage: 10.0%
     * - Mini Project Evaluation Weightage: 15.0%
     * - Mid Project Evaluation Weightage: 25.0%
     * - Final Project Evaluation Weightage: 50.0%
     * - Manager Evaluation Weightage: 20.0%
     * - Domain Weightage: 80.0%
     * - Training Weightage: 67.0%
     * - HR Interview Evaluation Weightage: 33.0%
     */
    @Transactional
    public void initializeWeightage() {
        if (weightageRepository.findAll().isEmpty()) {
            Weightage weightage = Weightage.builder()
                    .dailyTaskEvaluationWeightage(DEFAULT_DAILY_TASK_WEIGHTAGE)
                    .miniProjectEvaluationWeightage(DEFAULT_MINI_PROJECT_WEIGHTAGE)
                    .midProjectEvaluationWeightage(DEFAULT_MID_PROJECT_WEIGHTAGE)
                    .finalProjectEvaluationWeightage(DEFAULT_FINAL_PROJECT_WEIGHTAGE)
                    .managerEvaluationWeightage(DEFAULT_MANAGERS_EVALUATION_WEIGHTAGE)
                    .domainWeightage(DEFAULT_DOMAIN_WEIGHTAGE)
                    .trainingWeightage(DEFAULT_TRAINING_WEIGHTAGE)
                    .hrInterviewEvaluationWeightage(DEFAULT_HR_INTERVIEW_WEIGHTAGE)
                    .build();
            weightageRepository.save(weightage);
        }
    }
}
