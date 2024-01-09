import 'dart:collection';
import 'dart:convert';

import 'package:file_picker/src/platform_file.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/api/api_service.dart';
import 'package:front/models/Info_graphics_data.dart';
import 'package:front/models/batch.dart';
import 'package:front/models/final_score.dart';
import 'package:front/models/user_type.dart';
import 'package:front/models/weightage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';

import '../main.dart';
import '../models/Task.dart';
import '../models/api_response.dart';
import '../models/evaluation_final.dart';
import '../models/evaluation_hr.dart';
import '../models/evaluation_managers.dart';
import '../models/evaluation_task.dart';
import '../models/submission.dart';
import '../models/task_submission.dart';
import '../models/user.dart';
import '../pages/widgets/toasts.dart';

class AppController extends ChangeNotifier {
  FToast fToast = FToast();
  final LocalStorage store ;
  late ApiService apiService;
  late List<Batch> batches;
  late List<User> trainees;
  late List<User> trainers;
  late List<User> unassignedTrainees;
  bool isLoading = false;
  late List<Task> tasks ;
  bool isTaskLoading = false;
  List<EvaluationTask> evaluationTasks = [];
  List<EvaluationManagers> evaluationManagers= [];
  List<EvaluationHr> evaluationHrs= [];
  List<EvaluationFinal> evaluationFinalsProject= [];
  List<TaskSubmission> taskSubmission = [];
  late Weightage weightage ;
  late User user;
  bool userLoaded = false;


  Map< String?,int?> taskMap = {};
  var log = Logger();

  AppController(this.store){
    apiService = ApiService(store);
  }

  Future<Weightage?> getWeightage() async{

    var response = await apiService.getWeightage();
    if (response.status == ApiResponseStatus.success) {
      weightage = Weightage.fromJson(response.data);
      return weightage;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return null;

  }


  getData() async {
    isLoading = true;
    batches = await getAllBatch();
    trainees = await getAllTrainee();
    isLoading =  false;
    notifyListeners();
  }

  getMyBatchId(){

  }


  void getUnassignedTrainees() {
    // Collect all trainee IDs from the batches
    Set<int> assignedTraineeIds = Set<int>();
    for (var batch in batches) {
      if (batch.trainees != null) {
        for (var trainee in batch.trainees!) {
          assignedTraineeIds.add(trainee.userId!);
        }
      }
    }

    unassignedTrainees = trainees
        .where((trainee) => !assignedTraineeIds.contains(trainee.userId))
        .toList();
    notifyListeners();
  }

  Future<List<Batch>> getAllBatch() async {
    var response = await apiService.getAllBatch();
    batches = batchFromJson(json.encode(response.data));
    if (response.status == ApiResponseStatus.success) {
      notifyListeners();
      return batches;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }

    return List.empty();
  }

  Future<bool> addBatch(
      String name, String description, String startDate, String endDate) async {
    Batch batch = Batch(
        batchName: name,
        description: description,
        startDate: startDate,
        endDate: endDate);
    var response = await apiService.addBatch(batch);
    if (response.status == ApiResponseStatus.success) {
      getAllBatch();
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Batch created"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }

  Future<bool> updateBatch(int id, String name, String description,
      String startDate, String endDate, String status) async {
    Batch batch = Batch(
        id: id,
        batchName: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        status: bool.tryParse(status));
    var response = await apiService.updateBatch(batch);
    if (response.status == ApiResponseStatus.success) {
      getAllBatch();
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Batch updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }

  Future<List<User>> getAllTrainee() async {
    var response = await apiService.getAllUser(UserType.trainee);
    if (response.status == ApiResponseStatus.success) {
      trainees = userFromJson(json.encode(response.data));
      getUnassignedTrainees();
      notifyListeners();
      return trainees;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return List.empty();
  }
  Future<List<User>> getAllTrainers() async {
    var response = await apiService.getAllUser(UserType.trainer);
    if (response.status == ApiResponseStatus.success) {
      trainers = userFromJson(json.encode(response.data));
      getUnassignedTrainees();
      notifyListeners();
      return trainers;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return List.empty();
  }
  bool check(int userId, List<User> selectedTrainees) {
    for (var trainee in selectedTrainees) {
      if (trainee.userId == userId) {
        return true;
      }
    }
    return false;
  }

  Future<bool> addTrainee(Batch batch) async {
    batch.userIds = batch.trainees!.map((e) => e.userId).toList();
    var response = await apiService.updateBatch(batch);
    if (response.status == ApiResponseStatus.success) {
      getAllBatch();
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Trainee added"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }


   void getTaskMap({String? taskType,int? batchId})async{
     var tasks = await getTasks(taskType: taskType,batchId: batchId);
     taskMap = HashMap.fromEntries(tasks.map((task) => MapEntry(task.title,task.id,)));
     notifyListeners();
   }

  Future<List<Task>> getTasks({String? taskType,int? batchId}) async {

    isTaskLoading = true;
    var response = await apiService.getTask(batchId, taskType);
    if (response.status == ApiResponseStatus.success) {
      tasks = taskFromJson(json.encode(response.data));
      isTaskLoading = false;
      notifyListeners();
      return tasks;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return List.empty();

  }

  Future<bool> addTask(Task task) async {
    var response = await apiService.createTask(task);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Task added"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }
  Future<bool> downloadFile(int fileId) async {
    await apiService.downloadFile(fileId);
    return true;
  }

  Future<bool> updateTask(Task task) async {
    var response = await apiService.updateTask(task);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Task updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }


  Future<bool> getEvaluation({String? taskType,int? batchId}) async {
    final response;
    isTaskLoading = true;
    notifyListeners();
    if(taskType == "FINAL_PROJECT"){
      response = await apiService.getEvaluation(batchId!, taskType!);
      if (response.status == ApiResponseStatus.success) {
        evaluationFinalsProject = evaluationFinalFromJson(json.encode(response.data));
        notifyListeners();
      } else if (response.status == ApiResponseStatus.error) {
        log.e('error');
        log.d(response.data);
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast(response.data['message']),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );// Access the error data
      }
    }else if(taskType == "MANAGERS"){
      response = await apiService.getEvaluation(batchId!, taskType!);
      if (response.status == ApiResponseStatus.success) {
        evaluationManagers = evaluationManagersFromJson(json.encode(response.data));
        notifyListeners();
      } else if (response.status == ApiResponseStatus.error) {
        log.e('error');
        log.d(response.data);
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast(response.data['message']),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );// Access the error data
      }
    }
    else if(taskType == "CEO"){
      response = await apiService.getEvaluation(batchId!, taskType!);
      if (response.status == ApiResponseStatus.success) {
        evaluationHrs = evaluationHrFromJson(json.encode(response.data));
        notifyListeners();
      } else if (response.status == ApiResponseStatus.error) {
        log.e('error');
        log.d(response.data);
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast(response.data['message']),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );// Access the error data
      }
    }
    else {
      response = await apiService.getEvaluation(batchId!, taskType!);
      if (response.status == ApiResponseStatus.success) {
        evaluationTasks = evaluationTaskFromJson(json.encode(response.data));
        notifyListeners();
      } else if (response.status == ApiResponseStatus.error) {
        log.e('error');
        log.d(response.data);
        fToast.init(navigatorKey.currentContext!);
        fToast.showToast(
          child: showErrorToast(response.data['message']),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );// Access the error data
      }
    }
    isTaskLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> getSubmissionByTaskId(int taskId) async {
    var response = await apiService.getSubmissionByTaskId(taskId);
    if (response.status == ApiResponseStatus.success) {
      taskSubmission = taskSubmissionFromJson(json.encode(response.data));
      notifyListeners();
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }

  Future<Batch?> getBatch(int batchId) async {
    var response = await apiService.getBatch(batchId);

    if (response.status == ApiResponseStatus.success) {
      Batch batch = Batch.fromJson(response.data);
      return batch;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return null;
  }


  Future<EvaluationTask?> saveTaskEvaluation(EvaluationTask evaluation) async {
   log.d(evaluation);
    if(!evaluation.isValid(evaluation)){
      log.d(evaluation);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast("Invalid obtained mark"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
      return null;
    }


    var response = await apiService.saveTaskEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Mark saved"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationTask.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }

  Future<EvaluationTask?> updateTaskEvaluation(EvaluationTask evaluation) async {
    log.d(evaluation);
    if(!evaluation.isValid(evaluation)){
      log.d(evaluation);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast("Invalid obtained mark"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
      return null;
    }
    var response = await apiService.updateTaskEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Mark updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationTask.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }


  Future<EvaluationFinal?> saveFinalProjectEvaluation(EvaluationFinal evaluation) async {
    evaluation.setObtainedMarkIfNull(evaluation);
    var response = await apiService.saveFinalProjectEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation saved"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationFinal.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }

  Future<EvaluationFinal?> updateFinalEvaluation(EvaluationFinal evaluation) async {
    evaluation.setObtainedMarkIfNull(evaluation);
    var response = await apiService.updateFinalProjectEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationFinal.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }


  Future<EvaluationManagers?> saveManagersEvaluation(EvaluationManagers evaluation) async {
    evaluation.setObtainedMarkIfNull(evaluation);
    var response = await apiService.saveManagersEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation saved"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationManagers.fromJson(response.data);
    }
    else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }

  Future<EvaluationManagers?> updateManagersEvaluation(EvaluationManagers evaluation) async {
    evaluation.setObtainedMarkIfNull(evaluation);
    var response = await apiService.updateManagersEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationManagers.fromJson(response.data);
    }  else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }


  Future<EvaluationHr?> saveHrEvaluation(EvaluationHr evaluation) async {
    var response = await apiService.saveHrEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation saved"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationHr.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }



  Future<EvaluationHr?> updateHrEvaluation(EvaluationHr evaluation) async {
    var response = await apiService.updateHrEvaluation(evaluation);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Evaluation updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return EvaluationHr.fromJson(response.data);
    }else if(response.status == ApiResponseStatus.error){
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
    return null;
  }

  Future<bool?> updateWeightage(Weightage weightage) async {
    var response = await apiService.updateWeightage(weightage);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Weightage updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    }
    return false;
  }
  Future<List<FinalScore>> getFinalScore(int batchId,{bool recalculate = false})async{
    var response = await apiService.getFinalScore(batchId,recalculate);
    if (response.status == ApiResponseStatus.success) {
      return finalScoreFromJson(jsonEncode(response.data));
    }
     else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return List.empty();
  }


  Future<List<Task>> getBatchId(int? userId,String taskType)async {
    batches = await getAllBatch();
    int? batchId;
    for (var batch in batches) {
      for (var trainee in batch.trainees!) {
        if (trainee.userId == userId) {
          batchId = batch.id;
        }
      }
    }
   var tasks = await getTasks(taskType: taskType,batchId: batchId);
    return tasks;
  }



  Future<Batch?> getBatchByUserId(int? userId)async {
    batches = await getAllBatch();
    int? batchId;
    for (var batch in batches) {
      for (var trainee in batch.trainees!) {
        if (trainee.userId == userId) {
          batchId = batch.id;
        }
      }
    }
    var batch = await getBatch(batchId!);
    return batch;
  }

  Future<List<Submission>> getSubmission(int taskId) async {

    var response = await apiService.getSubmission(taskId);
    if (response.status == ApiResponseStatus.success) {
      return submissionFromJson(json.encode(response.data));
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return List.empty();
  }
  Future<bool> submitTask({required int taskId, required int traineeId, required PlatformFile file}) async {

    var response = await apiService.submitTask(taskId,traineeId,file);
    if (response.status == ApiResponseStatus.success) {
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("Task Submitted"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }

  Future<User?> getUser(int userId) async {
    userLoaded = false;
    var response = await apiService.getUser(userId);
    if (response.status == ApiResponseStatus.success) {
      user = User.fromJson(response.data);
      userLoaded = true;
      notifyListeners();
      return user;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return null;
  }

  Future<bool> updateUser(User userupdated) async {
    var response = await apiService.updateUser(userupdated);
    if (response.status == ApiResponseStatus.success) {
      user = User.fromJson(response.data);
      notifyListeners();
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showSuccessToast("User updated"),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
      return true;
    } else if (response.status == ApiResponseStatus.error) {
      log.e('error');
      log.d(response.data);
      fToast.init(navigatorKey.currentContext!);
      fToast.showToast(
        child: showErrorToast(response.data['message']),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );// Access the error data
    }
    return false;
  }

  List<EvaluationTask> filterTask(int taskId){
    List<EvaluationTask> newList = [];
    evaluationTasks.forEach((element) {
      if(element.taskId == taskId){
        newList.add(element);
      }
    });
    return newList;
  }

  Future<InfoGraphicsData> getInfoGraphicsData ()async {
   int traineeCount = 0 ;
   int trainerCount =0;
   int batchCount =0;
   List<FinalScore> finalScores = [];

  var countData = await apiService.getUserCount();
  if (countData.status == ApiResponseStatus.success) {
    traineeCount= countData.data['traineeCount'];
    trainerCount = countData.data['trainerCount'];
  } else if (countData.status == ApiResponseStatus.error) {
  }
  var batchList = await getAllBatch();
  batchCount= batchList.length;

    var finalScore = await apiService.getAllFinalScore();
    if (finalScore.status == ApiResponseStatus.success) {
      var result = finalScoreFromJson(json.encode(finalScore.data));
      finalScores.addAll(result);
    } else if (finalScore.status == ApiResponseStatus.error) {
      log.e(finalScore.data);
    }
    return InfoGraphicsData(traineeCount, trainerCount, batchCount, finalScores,batchList);

  }




}
