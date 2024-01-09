
import 'dart:convert';

Weightage weightageFromJson(String str) => Weightage.fromJson(json.decode(str));

String weightageToJson(Weightage data) => json.encode(data.toJson());

class Weightage {
  int? id;
  double? dailyTaskEvaluationWeightage;
  double? miniProjectEvaluationWeightage;
  double? midProjectEvaluationWeightage;
  double? finalProjectEvaluationWeightage;
  double? domainWeightage;
  double? managerEvaluationWeightage;
  double? trainingWeightage;
  double? hrInterviewEvaluationWeightage;

  Weightage({
    this.id,
    this.dailyTaskEvaluationWeightage,
    this.miniProjectEvaluationWeightage,
    this.midProjectEvaluationWeightage,
    this.finalProjectEvaluationWeightage,
    this.domainWeightage,
    this.managerEvaluationWeightage,
    this.trainingWeightage,
    this.hrInterviewEvaluationWeightage,
  });

  factory Weightage.fromJson(Map<String, dynamic> json) => Weightage(
    id: json["id"],
    dailyTaskEvaluationWeightage: json["dailyTaskEvaluationWeightage"],
    miniProjectEvaluationWeightage: json["miniProjectEvaluationWeightage"],
    midProjectEvaluationWeightage: json["midProjectEvaluationWeightage"],
    finalProjectEvaluationWeightage: json["finalProjectEvaluationWeightage"],
    domainWeightage: json["domainWeightage"],
    managerEvaluationWeightage: json["managerEvaluationWeightage"],
    trainingWeightage: json["trainingWeightage"],
    hrInterviewEvaluationWeightage: json["hrInterviewEvaluationWeightage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dailyTaskEvaluationWeightage": dailyTaskEvaluationWeightage,
    "miniProjectEvaluationWeightage": miniProjectEvaluationWeightage,
    "midProjectEvaluationWeightage": midProjectEvaluationWeightage,
    "finalProjectEvaluationWeightage": finalProjectEvaluationWeightage,
    "domainWeightage": domainWeightage,
    "managerEvaluationWeightage": managerEvaluationWeightage,
    "trainingWeightage": trainingWeightage,
    "hrInterviewEvaluationWeightage": hrInterviewEvaluationWeightage,
  };
}