package com.bjitacademy.sajal48.ems.application.config;
import com.bjitacademy.sajal48.ems.domian.batch.BatchService;
import com.bjitacademy.sajal48.ems.domian.credential.UserCredentialService;
import com.bjitacademy.sajal48.ems.domian.evaluation.EvaluationService;
import com.bjitacademy.sajal48.ems.domian.evaluation.WeightageService;
import com.bjitacademy.sajal48.ems.domian.file.FileService;
import com.bjitacademy.sajal48.ems.domian.scoreGeneration.ScoreGenerationService;
import com.bjitacademy.sajal48.ems.domian.task.TaskService;
import com.bjitacademy.sajal48.ems.domian.userDetails.UserInfoService;
import com.bjitacademy.sajal48.ems.infastructure.batch.BatchJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.evaluation.AptitudeAndHrEvaluationJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.evaluation.FinalProjectEvaluationJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.evaluation.ManagerEvaluationJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.evaluation.TaskEvaluationJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.fileinfo.FileInfoJpaInfoRepository;
import com.bjitacademy.sajal48.ems.infastructure.finalScore.FeedBackJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.finalScore.FinalScoreJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.task.TaskJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.task.TaskSubmissionJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.userCredential.RoleJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.userCredential.UserCredentialJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.userInfo.UserInfoJpaRepository;
import com.bjitacademy.sajal48.ems.infastructure.weightage.WeightageJpaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
@RequiredArgsConstructor
public class CoreConfig {
    private final UserCredentialJpaRepository userCredentialJpaRepository;
    private final RoleJpaRepository roleJpaRepository;
    private final UserInfoJpaRepository userInfoJpaRepository;
    private final FileInfoJpaInfoRepository fileInfoJpaInfoRepository;
    private final BatchJpaRepository batchJpaRepository;
    private final WeightageJpaRepository weightageJpaRepository;
    private final TaskJpaRepository taskJpaRepository;
    private final TaskSubmissionJpaRepository taskSubmissionJpaRepository;
    private final AptitudeAndHrEvaluationJpaRepository aptitudeAndHrEvaluationJpaRepository;
    private final FinalProjectEvaluationJpaRepository finalProjectEvaluationJpaRepository;
    private final ManagerEvaluationJpaRepository managerEvaluationJpaRepository;
    private final TaskEvaluationJpaRepository taskEvaluationJpaRepository;
    private final FinalScoreJpaRepository finalScoreJpaRepository;
    private final FeedBackJpaRepository feedBackJpaRepository;
    @Bean
    UserCredentialService getUserCredentialService() {
        return new UserCredentialService(userCredentialJpaRepository, roleJpaRepository);
    }
    @Bean
    UserInfoService getUserInfoService() {
        return new UserInfoService(userInfoJpaRepository);
    }
    @Bean
    FileService getFileService() {
        return new FileService(fileInfoJpaInfoRepository);
    }
    @Bean
    BatchService getBatchService() {
        return new BatchService(batchJpaRepository, userInfoJpaRepository);
    }
    @Bean
    WeightageService getWeightageService() {
        return new WeightageService(weightageJpaRepository);
    }
    @Bean
    TaskService getTaskService() {
        return new TaskService(taskJpaRepository, taskSubmissionJpaRepository);
    }
    @Bean
    ScoreGenerationService getScoresGenerationService() {
        return new ScoreGenerationService(weightageJpaRepository, taskEvaluationJpaRepository, finalProjectEvaluationJpaRepository, managerEvaluationJpaRepository, aptitudeAndHrEvaluationJpaRepository, finalScoreJpaRepository, batchJpaRepository, feedBackJpaRepository);
    }
    @Bean
    EvaluationService getEvaluationService() {
        return new EvaluationService(taskEvaluationJpaRepository, finalProjectEvaluationJpaRepository, managerEvaluationJpaRepository, aptitudeAndHrEvaluationJpaRepository);
    }
}