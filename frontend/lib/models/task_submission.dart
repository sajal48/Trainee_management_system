
import 'dart:convert';

List<TaskSubmission> taskSubmissionFromJson(String str) => List<TaskSubmission>.from(json.decode(str).map((x) => TaskSubmission.fromJson(x)));

String taskSubmissionToJson(List<TaskSubmission> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskSubmission {
  int? id;
  int? taskId;
  String? description;
  int? fileId;
  int? traineeId;

  TaskSubmission({
    this.id,
    this.taskId,
    this.description,
    this.fileId,
    this.traineeId,
  });

  factory TaskSubmission.fromJson(Map<String, dynamic> json) => TaskSubmission(
    id: json["id"],
    taskId: json["taskId"],
    description: json["description"],
    fileId: json["fileId"],
    traineeId: json["traineeId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "taskId": taskId,
    "description": description,
    "fileId": fileId,
    "traineeId": traineeId,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskSubmission &&
          runtimeType == other.runtimeType &&
          traineeId == other.traineeId;

  @override
  int get hashCode => traineeId.hashCode;
}
