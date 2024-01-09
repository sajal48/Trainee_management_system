
import 'dart:convert';

import 'feedback.dart';

List<FinalScore> finalScoreFromJson(String str) => List<FinalScore>.from(json.decode(str).map((x) => FinalScore.fromJson(x)));

String finalScoreToJson(List<FinalScore> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FinalScore {
  int? id;
  int? traineeId;
  int? batchId;
  double? totalScore;
  double? dailyTask;
  double? miniProjectScore;
  double? midProjectScore;
  double? finalProjectScore;
  double? managersEvaluationScore;
  double? hrEvaluationScore;
  double? domainScore;
  double? trainingTotalScore;
  List<FeedBack>? feedBacks;

  FinalScore({
    this.id,
    this.traineeId,
    this.batchId,
    this.totalScore,
    this.dailyTask,
    this.miniProjectScore,
    this.midProjectScore,
    this.finalProjectScore,
    this.managersEvaluationScore,
    this.hrEvaluationScore,
    this.domainScore,
    this.trainingTotalScore,
    this.feedBacks,
  });

  factory FinalScore.fromJson(Map<String, dynamic> json) => FinalScore(
    id: json["id"],
    traineeId: json["traineeId"],
    batchId: json["batchId"],
    totalScore: json["totalScore"],
    dailyTask: json["dailyTask"],
    miniProjectScore: json["miniProjectScore"],
    midProjectScore: json["midProjectScore"],
    finalProjectScore: json["finalProjectScore"],
    managersEvaluationScore: json["managersEvaluationScore"],
    hrEvaluationScore: json["hrEvaluationScore"],
    domainScore: json["domainScore"],
    trainingTotalScore: json["trainingTotalScore"],
    feedBacks: json["feedBacks"] == null ? [] : List<FeedBack>.from(json["feedBacks"]!.map((x) => FeedBack.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "traineeId": traineeId,
    "batchId": batchId,
    "totalScore": totalScore,
    "dailyTask": dailyTask,
    "miniProjectScore": miniProjectScore,
    "midProjectScore": midProjectScore,
    "finalProjectScore": finalProjectScore,
    "managersEvaluationScore": managersEvaluationScore,
    "hrEvaluationScore": hrEvaluationScore,
    "domainScore": domainScore,
    "trainingTotalScore": trainingTotalScore,
    "feedBacks": feedBacks == null ? [] : List<dynamic>.from(feedBacks!.map((x) => x.toJson())),
  };
}

