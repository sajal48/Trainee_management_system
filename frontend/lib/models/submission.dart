// To parse this JSON data, do
//
//     final submission = submissionFromJson(jsonString);

import 'dart:convert';

import 'package:file_picker/file_picker.dart';

List<Submission> submissionFromJson(String str) => List<Submission>.from(json.decode(str).map((x) => Submission.fromJson(x)));

String submissionToJson(List<Submission> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Submission {
  int? id;
  int? taskId;
  String? description;
  int? fileId;
  int traineeId;
  PlatformFile? file;

  Submission({
     this.id,
     this.taskId,
     this.description,
     this.fileId,
     required this.traineeId,
    PlatformFile? file
  });

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
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
}
