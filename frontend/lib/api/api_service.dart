import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:front/models/Task.dart';
import 'package:front/models/api_response.dart';
import 'package:front/models/batch.dart';
import 'package:front/models/evaluation_final.dart';
import 'package:front/models/evaluation_hr.dart';
import 'package:front/models/evaluation_task.dart';
import 'package:front/models/user_type.dart';
import 'package:front/models/weightage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';
import 'package:universal_html/html.dart' as html;

import '../models/evaluation_managers.dart';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = "http://localhost:8080/api/v1";
  static const String _registerUrl = "$_baseUrl/auth/register";
  static const String _loginUrl = "$_baseUrl/auth/login";
  static const String _userUrl = "$_baseUrl/user";
  static const String _taskUrl = "$_baseUrl/task";

  static const String _batchUrl = "$_baseUrl/batch";
  static const String _fileUrl = "$_baseUrl/file";
  static const String _evaluationUrl = "$_baseUrl/evaluation";
  static const String _finalScoreUrl = "$_baseUrl/final-score";
  Logger log = Logger();

  late Dio _dio;
  final LocalStorage _store;

  ApiService(this._store) {
    _dio = Dio();
  }

  Options _getOptions() {
    final token = _store.getItem("JwtToken");
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<ApiResponse> register(
      String email, String password, UserType userType) async {
    String url = _registerUrl;

    if (userType == UserType.admin) {
      url += '/admin';
    } else if (userType == UserType.trainee) {
      url += '/trainee';
    } else if (userType == UserType.trainer) {
      url += '/trainer';
    }
    try {
      final response = await _dio.post(url, data: {
        "email": email,
        "password": password,
      });
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(_loginUrl, data: {
        "email": email,
        "password": password,
      });
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getAllBatch() async {
    try {
      final options = _getOptions();
      final Response response = await _dio.get(_batchUrl, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> addBatch(Batch batch) async {
    try {
      final options = _getOptions();
      final Response response =
          await _dio.post(_batchUrl, data: batch.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateBatch(Batch batch) async {
    try {
      final options = _getOptions();
      String updateUri = '$_batchUrl/${batch.id!}';
      final Response response =
          await _dio.put(updateUri, data: batch.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getAllUser(UserType userType) async {
    try {
      final options = _getOptions();
      final Response response = await _dio.get(_userUrl,
          queryParameters: {
            'userType': userType.name,
          },
          options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getTask(int? batchId, String? taskType) async {
    try {
      final options = _getOptions();
      final Map<String, dynamic> queryParameters = {};

      if (batchId != null) {
        queryParameters['batchId'] = batchId;
      }
      if (taskType != null) {
        queryParameters['taskType'] = taskType;
      }
      final Response response = await _dio.get(_taskUrl,
          queryParameters: queryParameters, options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> createTask(Task task) async {
    FormData formData = FormData.fromMap({
      'id': task.id,
      'assignedBy': task.assignedBy,
      'batchId': task.batchId,
      'title': task.title,
      'description': task.description,
      'taskType': task.taskType,
      'fileId': task.fileId,
      'createdAt': task.createdAt,
      'submissionDate': task.submissionDate,
    });

    if (task.file != null) {
      List<int> fileBytes = task.file!.bytes!;
      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: task.file!.name,
      );
      formData.files.add(MapEntry('file', multipartFile));
    }

    try {
      final options = _getOptions();
      final Response response =
          await _dio.post(_taskUrl, data: formData, options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateTask(Task task) async {
    FormData formData = FormData.fromMap({
      'id': task.id,
      'assignedBy': task.assignedBy,
      'batchId': task.batchId,
      'title': task.title,
      'description': task.description,
      'taskType': task.taskType,
      'fileId': task.fileId,
      'createdAt': task.createdAt,
      'submissionDate': task.submissionDate,
    });

    if (task.file != null) {
      List<int> fileBytes = task.file!.bytes!;
      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: task.file!.name,
      );
      formData.files.add(MapEntry('file', multipartFile));
    }
    int id = task.id!;
    String url = "$_taskUrl/$id";
    try {
      final options = _getOptions();
      final Response response =
          await _dio.put(url, data: formData, options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<bool> downloadFile(int fileId) async {
    String url = "$_fileUrl/$fileId";

    html.window.open(url, "_blank");

    return true;
  }

  Future<ApiResponse> getEvaluation(int batchId, String taskType) async {
    try {
      final options = _getOptions();
      final Map<String, dynamic> queryParameters = {
        'batchId': batchId,
        'taskType': taskType,
      };

      final Response response = await _dio.get(_evaluationUrl,
          queryParameters: queryParameters, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getSubmissionByTaskId(int taskId) async {
    try {
      final options = _getOptions();
      String url = "$_taskUrl/submission/task/$taskId";

      final Response response = await _dio.get(url, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getBatch(int batchId) async {
    try {
      final options = _getOptions();
      String url = "$_batchUrl/$batchId";
      final Response response = await _dio.get(url, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> saveTaskEvaluation(EvaluationTask evaluation) async {
    try {
      final options = _getOptions();
      final Response response = await _dio.post(_evaluationUrl,
          data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateTaskEvaluation(EvaluationTask evaluation) async {
    try {
      final options = _getOptions();
      String url = "$_evaluationUrl/${evaluation.id}";
      final Response response =
          await _dio.put(url, data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> saveFinalProjectEvaluation(
      EvaluationFinal evaluation) async {
    try {
      final options = _getOptions();
      final Response response = await _dio.post("$_evaluationUrl/final-project",
          data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateFinalProjectEvaluation(
      EvaluationFinal evaluation) async {
    try {
      final options = _getOptions();
      String url = "$_evaluationUrl/final-project/${evaluation.id}";
      final Response response =
          await _dio.put(url, data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> saveManagersEvaluation(
      EvaluationManagers evaluation) async {
    try {
      final options = _getOptions();
      final Response response = await _dio.post("$_evaluationUrl/manager",
          data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateManagersEvaluation(
      EvaluationManagers evaluation) async {
    try {
      final options = _getOptions();
      String url = "$_evaluationUrl/manager/${evaluation.id}";
      final Response response =
          await _dio.put(url, data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> saveHrEvaluation(EvaluationHr evaluation) async {
    try {
      final options = _getOptions();
      final Response response = await _dio.post("$_evaluationUrl/ceo",
          data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateHrEvaluation(EvaluationHr evaluation) async {
    try {
      final options = _getOptions();
      String url = "$_evaluationUrl/ceo/${evaluation.id}";
      final Response response =
          await _dio.put(url, data: evaluation.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getWeightage() async {
    try {
      final options = _getOptions();
      String url = "$_baseUrl/weight";
      final Response response = await _dio.get(url, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateWeightage(Weightage weightage) async {
    try {
      final options = _getOptions();
      String url = "$_baseUrl/weight";
      final Response response =
          await _dio.put(url, data: weightage.toJson(), options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getFinalScore(int batchId, bool recalculate) async {
    try {
      final options = _getOptions();
      final Map<String, dynamic> queryParams = {
        'recalculate': recalculate.toString(),
      };

      final Response response = await _dio.get('$_finalScoreUrl/$batchId',
          queryParameters: queryParams, options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getAllFinalScore() async {
    try {
      final options = _getOptions();

      final Response response =
          await _dio.get(_finalScoreUrl, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getSubmission(int taskID) async {
    try {
      final options = _getOptions();
      final Response response =
          await _dio.get('$_taskUrl/submission/task/$taskID', options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> submitTask(
      int taskId, int traineeId, PlatformFile file) async {
    FormData formData = FormData.fromMap({
      'taskId': taskId,
      'traineeId': traineeId,
    });

    List<int> fileBytes = file.bytes!;
    MultipartFile multipartFile = MultipartFile.fromBytes(
      fileBytes,
      filename: file.name,
    );
    formData.files.add(MapEntry('file', multipartFile));
    log.d(formData.toString());
    String url = "$_taskUrl/submit";
    try {
      final options = _getOptions();
      final Response response =
          await _dio.post(url, data: formData, options: options);
      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getUser(int userId) async {
    try {
      final options = _getOptions();
      final Response response =
          await _dio.get('$_baseUrl/user/$userId', options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> updateUser(User user) async {
    try {
      final options = _getOptions();
      FormData formData = FormData.fromMap({
        'fullName': user.fullName,
        'contactNo': user.contactNo,
        'dob': user.dob,
        'educationalInstitute': user.educationalInstitute,
        'degreeName': user.degreeName,
        'passingYear': user.passingYear,
        'cgpa': user.cgpa,
        'designation': user.designation,
        'expertise': user.expertise,
        'joiningDate': user.joiningDate,
        'presentAddress': user.presentAddress,
      });

      if (user.file != null) {
        List<int> fileBytes = user.file!.bytes!;
        MultipartFile multipartFile = MultipartFile.fromBytes(
          fileBytes,
          filename: user.file!.name,
        );
        formData.files.add(MapEntry('file', multipartFile));
      }

      int id = user.userId!;
      final Response response = await _dio.post('$_baseUrl/user/$id',
          data: formData, options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }

  Future<ApiResponse> getUserCount() async {
    try {
      final options = _getOptions();
      final Response response =
          await _dio.get('$_baseUrl/user/count', options: options);

      return ApiResponse.success(response.data);
    } on DioException catch (ex) {
      return ApiResponse.error(ex.response?.data);
    }
  }
}
