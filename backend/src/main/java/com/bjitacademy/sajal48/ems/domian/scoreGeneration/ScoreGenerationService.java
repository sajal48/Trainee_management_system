package com.bjitacademy.sajal48.ems.domian.scoreGeneration;
import com.bjitacademy.sajal48.ems.domian.batch.BatchRepository;
import com.bjitacademy.sajal48.ems.domian.evaluation.*;
import com.bjitacademy.sajal48.ems.domian.exception.DatabaseException;
import com.bjitacademy.sajal48.ems.domian.task.TaskTypes;
import org.apache.commons.math3.util.Precision;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import static com.bjitacademy.sajal48.ems.domian.strings.Values.*;
public class ScoreGenerationService {
    private final WeightageRepository weightageRepository;
    private final TaskEvaluationRepository taskEvaluationRepository;
    private final FinalProjectEvaluationRepository finalProjectEvaluationRepository;
    private final ManagerEvaluationRepository managerEvaluationRepository;
    private final AptitudeAndHrEvaluationRepository aptitudeAndHrEvaluation;
    private final FinalScoreRepository finalScoreRepository;
    private final BatchRepository batchRepository;
    private final FeedBackRepository feedBackRepository;
    public ScoreGenerationService(WeightageRepository weightageRepository, TaskEvaluationRepository taskEvaluationRepository, FinalProjectEvaluationRepository finalProjectEvaluationRepository, ManagerEvaluationRepository managerEvaluationRepository, AptitudeAndHrEvaluationRepository aptitudeAndHrEvaluation, FinalScoreRepository finalScoreRepository, BatchRepository batchRepository, FeedBackRepository feedBackRepository) {
        this.weightageRepository = weightageRepository;
        this.taskEvaluationRepository = taskEvaluationRepository;
        this.finalProjectEvaluationRepository = finalProjectEvaluationRepository;
        this.managerEvaluationRepository = managerEvaluationRepository;
        this.aptitudeAndHrEvaluation = aptitudeAndHrEvaluation;
        this.finalScoreRepository = finalScoreRepository;
        this.batchRepository = batchRepository;
        this.feedBackRepository = feedBackRepository;
    }
    /**
     * Retrieves the weightage information from the database.
     *
     * @return The Weightage object containing the weightage information.
     * @throws DatabaseException If there is an error retrieving the weightage information from the database.
     */
    private Weightage getWeightage() {
        try {
            var datalist = weightageRepository.findAll();
            return datalist.get(0);
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
    /**
     * Retrieves the list of user IDs associated with a batch from the database.
     *
     * @param batchId The ID of the batch.
     * @return A list of user IDs associated with the batch.
     * @throws DatabaseException If there is an error retrieving the batch information from the database or extracting the user IDs.
     */
    private List<Long> getTraineeIds(Long batchId) {
        var dataList = batchRepository.findBatchById(batchId).orElseThrow();
        try {
            return dataList.getTrainees().stream().map(e -> e.getUserId()).toList();
        } catch (Exception e) {
            throw new DatabaseException(TRAINEE_FETCH_ERROR);
        }
    }
    /**
     * Calculates the sum of obtained marks and total marks for a specific type of evaluation for a given trainee.
     *
     * @param traineeId The ID of the trainee.
     * @param type      The type of evaluation.
     * @return The TaskEvaluation object containing the sum of obtained marks and total marks.
     */
    private TaskEvaluation getEvaluationSum(Long traineeId, TaskTypes type) {
        double totalObtainedMark = 0.0;
        double totalMark = 0.0;
        if (type.equals(TaskTypes.DAILY_TASK) || type.equals(TaskTypes.MINI_PROJECT) || type.equals(TaskTypes.MID_PROJECT)) {
            var data = taskEvaluationRepository.findAllByTraineeIdAndEvaluationType(traineeId, type.name());
            if (!data.isEmpty()) {
                for (TaskEvaluation evaluation : data) {
                    totalObtainedMark += (evaluation.getObtainedMark() != null) ? evaluation.getObtainedMark() : 0.0;
                    totalMark += (evaluation.getTotalMark() != null) ? evaluation.getTotalMark() : 0.0;
                }
            }
        } else if (type.equals(TaskTypes.FINAL_PROJECT)) {
            var data = finalProjectEvaluationRepository.findAllByTraineeId(traineeId);
            if (!data.isEmpty()) {
                for (FinalProjectEvaluation evaluation : data) {
                    totalObtainedMark += (evaluation.getObtainedMark() != null) ? evaluation.getObtainedMark() : 0.0;
                    totalMark += (evaluation.getTotalMark() != null) ? evaluation.getTotalMark() : 0.0;
                }
            }
        } else if (type.equals(TaskTypes.MANAGERS)) {
            var data = managerEvaluationRepository.findAllByTraineeId(traineeId);
            if (!data.isEmpty()) {
                for (ManagerEvaluation evaluation : data) {
                    totalObtainedMark += (evaluation.getObtainedMark() != null) ? evaluation.getObtainedMark() : 0.0;
                    totalMark += (evaluation.getTotalMark() != null) ? evaluation.getTotalMark() : 0.0;
                }
            }
        } else {
            var data = aptitudeAndHrEvaluation.findAllByTraineeId(traineeId);
            if (!data.isEmpty()) {
                for (AptitudeAndHrEvaluation evaluation : data) {
                    totalObtainedMark += (evaluation.getObtainedMark() != null) ? evaluation.getObtainedMark() : 0.0;
                    totalMark += (evaluation.getTotalMark() != null) ? evaluation.getTotalMark() : 0.0;
                }
            }
        }
        return TaskEvaluation.builder()
                .traineeId(traineeId)
                .obtainedMark(totalObtainedMark)
                .totalMark(totalMark)
                .build();
    }
    /**
     * Applies weightage to obtained marks based on the total marks and weightage provided.
     *
     * @param totalMark    The total marks for the evaluation.
     * @param obtainedMark The obtained marks for the evaluation.
     * @param weightage    The weightage to be applied.
     * @return The weighted mark after applying the weightage.
     * Returns {@code null} if any of the parameters are {@code null}.
     */
    private double applyWeightage(double totalMark, double obtainedMark, double weightage) {
        if (Double.isNaN(totalMark) || Double.isNaN(obtainedMark) || Double.isNaN(weightage) || totalMark == 0.0) {
            return 0.0;
        }
        return (obtainedMark / totalMark) * weightage;
    }
    /**
     * Applies weightage to obtained marks based on the weightage provided.
     * Assumes that the obtained marks are in the range of 0 to 100.
     *
     * @param obtainedMark The obtained marks for the evaluation (in the range of 0 to 100).
     * @param weightage    The weightage to be applied.
     * @return The weighted mark after applying the weightage.
     * Returns {@code null} if any of the parameters are {@code null}.
     */
    private double applyWeightage(double obtainedMark, double weightage) {
        if (Double.isNaN(obtainedMark) || Double.isNaN(weightage) || obtainedMark == 0.0) {
            return 0.0;
        }
        return (obtainedMark / 100) * weightage;
    }
    /**
     * Generates the final scores for the trainees in the specified batch.
     *
     * @param batchId     The ID of the batch for which to generate scores.
     * @param recalculate If set to true, the final scores will be recalculated even if they are already available in the database.
     *                    If set to false, the method will return the existing final scores from the database, if available.
     * @return The list of final scores for the trainees in the specified batch. If 'recalculate' is false and the scores are not available in the database, an empty list will be returned.
     * @throws DatabaseException If there is a problem accessing or manipulating the database.
     */
    public List<FinalScore> generateScore(Long batchId, boolean recalculate) {
        if (recalculate) {
            finalScoreRepository.removeWhereBatchId(batchId);
        }
        var results = finalScoreRepository.findAllByBatchId(batchId);
        if (!results.isEmpty()) {
            return results;
        }
        Weightage weightage = getWeightage();
        List<Long> traineeIds = getTraineeIds(batchId);
        List<FinalScore> finalScoreList = new ArrayList<>();
        traineeIds.forEach(trainee -> {
            // get all summed up marks for evaluations
            var dailyEvaluation = getEvaluationSum(trainee, TaskTypes.DAILY_TASK);
            var miniProjectEvaluation = getEvaluationSum(trainee, TaskTypes.MINI_PROJECT);
            var midProjectEvaluation = getEvaluationSum(trainee, TaskTypes.MID_PROJECT);
            var finalProjectEvaluation = getEvaluationSum(trainee, TaskTypes.FINAL_PROJECT);
            var managersEvaluation = getEvaluationSum(trainee, TaskTypes.MANAGERS);
            var ceoEvaluation = getEvaluationSum(trainee, TaskTypes.CEO);
            // apply weightage
            double dailyWeightedMark = applyWeightage(dailyEvaluation.getTotalMark(), dailyEvaluation.getObtainedMark(), weightage.getDailyTaskEvaluationWeightage());
            double miniProjectWeightedMark = applyWeightage(miniProjectEvaluation.getTotalMark(), miniProjectEvaluation.getObtainedMark(), weightage.getMiniProjectEvaluationWeightage());
            double midProjectWeightedMark = applyWeightage(midProjectEvaluation.getTotalMark(), midProjectEvaluation.getObtainedMark(), weightage.getMidProjectEvaluationWeightage());
            double finalProjectWeightedMark = applyWeightage(finalProjectEvaluation.getTotalMark(), finalProjectEvaluation.getObtainedMark(), weightage.getFinalProjectEvaluationWeightage());
            double domainMark = dailyWeightedMark + miniProjectWeightedMark + midProjectWeightedMark + finalProjectWeightedMark;  //dailyWeightedMark,miniProjectWeightedMark,midProjectWeightedMark,finalProjectWeightedMark sums up to domainMark
            double domainWeightedMark = applyWeightage(domainMark, weightage.getDomainWeightage());
            double managersWeightedMark = applyWeightage(managersEvaluation.getTotalMark(), managersEvaluation.getObtainedMark(), weightage.getManagerEvaluationWeightage());
            double trainingMark = domainWeightedMark + managersWeightedMark;
            double trainingWeightedMark = applyWeightage(trainingMark, weightage.getTrainingWeightage());
            double ceoWeightedMark = applyWeightage(ceoEvaluation.getTotalMark(), ceoEvaluation.getObtainedMark(), weightage.getHrInterviewEvaluationWeightage());
            double finalMark = trainingWeightedMark + ceoWeightedMark;
            FinalScore finalScore = FinalScore.builder()
                    .traineeId(trainee)
                    .batchId(batchId)
                    .dailyTask(Precision.round(dailyWeightedMark, 2))
                    .miniProjectScore(Precision.round(miniProjectWeightedMark, 2))
                    .midProjectScore(Precision.round(midProjectWeightedMark, 2))
                    .finalProjectScore(Precision.round(finalProjectWeightedMark, 2))
                    .domainScore(Precision.round(domainMark, 2))
                    .managersEvaluationScore(Precision.round(managersWeightedMark, 2))
                    .trainingTotalScore(Precision.round(trainingMark, 2))
                    .hrEvaluationScore(Precision.round(ceoWeightedMark, 2))
                    .totalScore(Precision.round(finalMark, 2))
                    .build();
            finalScoreList.add(finalScore);
        });
        try {
            return finalScoreRepository.saveAll(finalScoreList);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            throw new DatabaseException(SCORE_GENERATION_FAILURE);
        }
    }
    /**
     * Adds a feedback to a specific final score.
     *
     * @param finalScoreId The ID of the final score to which the feedback will be added.
     * @param feedBack     The feedback to be added.
     * @return The updated final score after adding the feedback.
     * @throws DatabaseException      if there is a problem accessing or manipulating the database.
     * @throws NoSuchElementException If no Score is found with the given ID.
     */
    public FinalScore addFeedback(Long finalScoreId, FeedBack feedBack) {
        FinalScore finalScore = finalScoreRepository.findById(finalScoreId).orElseThrow();
        try {
            FeedBack storedFeedback = feedBackRepository.save(feedBack);
            finalScore.getFeedBacks().add(storedFeedback);
            return finalScoreRepository.save(finalScore);
        } catch (Exception e) {
            throw new DatabaseException(FEEDBACK_ADD_FAILURE);
        }
    }
    /**
     * Updates the message of a specific feedback.
     *
     * @param id      The ID of the feedback to be updated.
     * @param message The new message for the feedback.
     * @return The updated feedback after the message has been updated.
     * @throws DatabaseException      if there is a problem accessing or manipulating the database.
     * @throws NoSuchElementException If no feedback is found with the given ID.
     */
    public FeedBack update(Long id, String message) {
        FeedBack storedFeedback = feedBackRepository.findById(id).orElseThrow();
        try {
            storedFeedback.setMessage(message);
            return feedBackRepository.save(storedFeedback);
        } catch (Exception e) {
            throw new DatabaseException(FEEDBACK_UPDATE_FAILURE);
        }
    }
    /**
     * Retrieves a list of FinalScore objects representing all the records available in the database.
     *
     * @return A List containing FinalScore objects representing the fetched data.
     * @throws DatabaseException If there is a failure while fetching data from the database.
     *                           The exception message will indicate the reason for the failure.
     */
    public List<FinalScore> getAll() {
        try {
            return finalScoreRepository.findAll();
        } catch (Exception e) {
            throw new DatabaseException(DB_DATA_FETCH_FAILURE);
        }
    }
}
