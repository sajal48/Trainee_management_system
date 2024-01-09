// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<EvaluationManagers> evaluationManagersFromJson(String str) => List<EvaluationManagers>.from(json.decode(str).map((x) => EvaluationManagers.fromJson(x)));

String evaluationManagersToJson(List<EvaluationManagers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationManagers {
  int? id;
  int? traineeId;
  int? batchId;
  double? totalMark;
  double? obtainedMark;
  double? bjitTools;
  double? officeRules;
  double? sincerity;
  double? quality;
  double? attendance;
  double? communicationSkill;
  double? englishLanguageSkill;

  EvaluationManagers({
    this.id,
    this.traineeId,
    this.batchId,
    this.totalMark,
    this.obtainedMark,
    this.bjitTools,
    this.officeRules,
    this.sincerity,
    this.quality,
    this.attendance,
    this.communicationSkill,
    this.englishLanguageSkill,
  });

  factory EvaluationManagers.fromJson(Map<String, dynamic> json) => EvaluationManagers(
    id: json["id"],
    traineeId: json["traineeId"],
    batchId: json["batchId"],
    totalMark: json["totalMark"]?.toDouble(),
    obtainedMark: json["obtainedMark"]?.toDouble(),
    bjitTools: json["bjitTools"]?.toDouble(),
    officeRules: json["officeRules"]?.toDouble(),
    sincerity: json["sincerity"]?.toDouble(),
    quality: json["quality"]?.toDouble(),
    attendance: json["attendance"]?.toDouble(),
    communicationSkill: json["communicationSkill"]?.toDouble(),
    englishLanguageSkill: json["englishLanguageSkill"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "traineeId": traineeId,
    "batchId": batchId,
    "totalMark": totalMark,
    "obtainedMark": obtainedMark,
    "bjitTools": bjitTools,
    "officeRules": officeRules,
    "sincerity": sincerity,
    "quality": quality,
    "attendance": attendance,
    "communicationSkill": communicationSkill,
    "englishLanguageSkill": englishLanguageSkill,
  };

  void setObtainedMarkIfNull(EvaluationManagers evaluationManagers) {

    // Calculate the sum of non-null marks and assign it to the obtainedMark field
    double sum = 0.0;
    if (evaluationManagers.bjitTools != null) sum += evaluationManagers.bjitTools!;
    if (evaluationManagers.officeRules != null) sum += evaluationManagers.officeRules!;
    if (evaluationManagers.sincerity != null) sum += evaluationManagers.sincerity!;
    if (quality != null) sum += evaluationManagers.quality!;
    if (evaluationManagers.attendance != null) sum += evaluationManagers.attendance!;
    if (evaluationManagers.communicationSkill != null) sum += evaluationManagers.communicationSkill!;
    if (evaluationManagers.englishLanguageSkill != null) sum += evaluationManagers.englishLanguageSkill!;


    evaluationManagers.obtainedMark = sum;

  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationManagers &&
          runtimeType == other.runtimeType &&
          traineeId == other.traineeId;

  @override
  int get hashCode => traineeId.hashCode;
}