
import 'dart:convert';

List<EvaluationTask> evaluationTaskFromJson(String str) => List<EvaluationTask>.from(json.decode(str).map((x) => EvaluationTask.fromJson(x)));

String evaluationTaskToJson(List<EvaluationTask> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationTask {
  int? id;
  int? taskId;
  int? batchId;
  int? traineeId;
  int? evaluatorId;
  String? evaluationType;
  String? taskType;
  String? evaluatedOn;
  double? totalMark;
  double? obtainedMark;
  double? requirementUnderstanding;
  double? expectedOutput;
  double? codeQuality;
  double? demonstrationOrPresentation;
  double? liveCodingOrCodeUnderstanding;


  EvaluationTask({
    this.id,
    this.taskId,
    this.batchId,
    this.traineeId,
    this.evaluatorId,
    this.evaluationType,
    this.evaluatedOn,
    this.totalMark,
    this.obtainedMark,
    this.requirementUnderstanding,
    this.expectedOutput,
    this.codeQuality,
    this.demonstrationOrPresentation,
    this.liveCodingOrCodeUnderstanding,
    this.taskType
  });

  factory EvaluationTask.fromJson(Map<String, dynamic> json) => EvaluationTask(
    id: json["id"],
    taskId: json["taskId"],
    batchId: json["batchId"],
    taskType: json["taskType"],
    traineeId: json["traineeId"],
    evaluatorId: json["evaluatorId"],
    evaluationType: json["evaluationType"],
    evaluatedOn: json["evaluatedOn"],
    totalMark: json["totalMark"],
    obtainedMark: json["obtainedMark"]?.toDouble(),
    requirementUnderstanding: json["requirementUnderstanding"]?.toDouble(),
    expectedOutput: json["expectedOutput"]?.toDouble(),
    codeQuality: json["codeQuality"]?.toDouble(),
    demonstrationOrPresentation: json["demonstrationOrPresentation"]?.toDouble(),
    liveCodingOrCodeUnderstanding: json["liveCodingOrCodeUnderstanding"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "taskType":taskType,
    "taskId": taskId,
    "batchId": batchId,
    "traineeId": traineeId,
    "evaluatorId": evaluatorId,
    "evaluationType": evaluationType,
    "evaluatedOn": evaluatedOn,
    "totalMark": totalMark,
    "obtainedMark": obtainedMark,
    "requirementUnderstanding": requirementUnderstanding,
    "expectedOutput": expectedOutput,
    "codeQuality": codeQuality,
    "demonstrationOrPresentation": demonstrationOrPresentation,
    "liveCodingOrCodeUnderstanding": liveCodingOrCodeUnderstanding,
  };

  double getObtainedMark(EvaluationTask evaluationTask) {
    double sum = 0.0;
    if (evaluationTask.requirementUnderstanding != null) sum += evaluationTask.requirementUnderstanding!;
    if (evaluationTask.expectedOutput != null) sum += evaluationTask.expectedOutput!;
    if (evaluationTask.codeQuality != null) sum += evaluationTask.codeQuality!;
    if (evaluationTask.demonstrationOrPresentation != null) sum += evaluationTask.demonstrationOrPresentation!;
    if (evaluationTask.liveCodingOrCodeUnderstanding != null) sum += evaluationTask.liveCodingOrCodeUnderstanding!;
    evaluationTask.obtainedMark = sum;
    return sum;
  }

  bool isValid(EvaluationTask evaluationTask) {
    // First, calculate the obtained mark using the existing method
    double obtainedMark = getObtainedMark(evaluationTask);
    print(obtainedMark);
    // Compare the obtained mark with the maximum number based on the task type
    if (evaluationTask.evaluationType == "DAILY_TASK") {// Replace with the appropriate maximum value
      return obtainedMark <= 10;
    } else if (evaluationTask.evaluationType == "MINI_PROJECT") {// Replace with the appropriate maximum value
      return obtainedMark <= 50;
    } else if (evaluationTask.evaluationType == "MID_PROJECT") {
      return obtainedMark <= 100;
    } else {
      // For other task types, return false (task not completed)
      return false;
    }
  }

  @override
  String toString() {
    return 'EvaluationTask{id: $id, taskId: $taskId, batchId: $batchId, traineeId: $traineeId, evaluatorId: $evaluatorId, evaluationType: $evaluationType, evaluatedOn: $evaluatedOn, totalMark: $totalMark, obtainedMark: $obtainedMark, requirementUnderstanding: $requirementUnderstanding, expectedOutput: $expectedOutput, codeQuality: $codeQuality, demonstrationOrPresentation: $demonstrationOrPresentation, liveCodingOrCodeUnderstanding: $liveCodingOrCodeUnderstanding}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationTask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskId == other.taskId &&
          batchId == other.batchId &&
          traineeId == other.traineeId &&
          evaluatorId == other.evaluatorId &&
          evaluationType == other.evaluationType &&
          taskType == other.taskType &&
          evaluatedOn == other.evaluatedOn &&
          totalMark == other.totalMark &&
          obtainedMark == other.obtainedMark &&
          requirementUnderstanding == other.requirementUnderstanding &&
          expectedOutput == other.expectedOutput &&
          codeQuality == other.codeQuality &&
          demonstrationOrPresentation == other.demonstrationOrPresentation &&
          liveCodingOrCodeUnderstanding == other.liveCodingOrCodeUnderstanding;

  @override
  int get hashCode =>
      id.hashCode ^
      taskId.hashCode ^
      batchId.hashCode ^
      traineeId.hashCode ^
      evaluatorId.hashCode ^
      evaluationType.hashCode ^
      taskType.hashCode ^
      evaluatedOn.hashCode ^
      totalMark.hashCode ^
      obtainedMark.hashCode ^
      requirementUnderstanding.hashCode ^
      expectedOutput.hashCode ^
      codeQuality.hashCode ^
      demonstrationOrPresentation.hashCode ^
      liveCodingOrCodeUnderstanding.hashCode;
}