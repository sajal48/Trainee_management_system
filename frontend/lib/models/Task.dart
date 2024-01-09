import 'dart:convert';

import 'package:file_picker/file_picker.dart';

List<Task> taskFromJson(String str) => List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskToJson(List<Task> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  int? id;
  int? assignedBy;
  int? batchId;
  String? title;
  String? description;
  String? taskType;
  int? fileId;
  String? createdAt;
  String? submissionDate;
  PlatformFile? file;
  PlatformFile? submissionFile;

  Task({
    this.id,
    this.assignedBy,
    this.batchId,
    this.title,
    this.description,
    this.taskType,
    this.fileId,
    this.createdAt,
    this.submissionDate,
    this.file
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    assignedBy: json["assignedBy"],
    batchId: json["batchId"],
    title: json["title"],
    description: json["description"],
    taskType: json["taskType"],
    fileId: json["fileId"],
    createdAt: json["createdAt"],
    submissionDate: json["submissionDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "assignedBy": assignedBy,
    "batchId": batchId,
    "title": title,
    "description": description,
    "taskType": taskType,
    "fileId": fileId,
    "createdAt": createdAt,
    "submissionDate": submissionDate,
  };

  @override
  String toString() {
    return 'Task{id: $id, assignedBy: $assignedBy, batchId: $batchId, title: $title, description: $description, taskType: $taskType, fileId: $fileId, createdAt: $createdAt, submissionDate: $submissionDate}';
  }
}