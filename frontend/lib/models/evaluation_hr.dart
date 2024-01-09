
import 'dart:convert';

List<EvaluationHr> evaluationHrFromJson(String str) => List<EvaluationHr>.from(json.decode(str).map((x) => EvaluationHr.fromJson(x)));

String evaluationHrToJson(List<EvaluationHr> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationHr {
  int? id;
  int? traineeId;
  int? batchId;
  double? hrInterviewMark;
  double? totalMark;
  double? obtainedMark;

  EvaluationHr({
    this.id,
    this.traineeId,
    this.batchId,
    this.hrInterviewMark,
    this.totalMark,
    this.obtainedMark,
  });

  factory EvaluationHr.fromJson(Map<String, dynamic> json) => EvaluationHr(
    id: json["id"],
    traineeId: json["traineeId"],
    batchId: json["batchId"],
    hrInterviewMark: json["hrInterviewMark"],
    totalMark: json["totalMark"],
    obtainedMark: json["obtainedMark"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "traineeId": traineeId,
    "batchId": batchId,
    "hrInterviewMark": hrInterviewMark,
    "totalMark": totalMark,
    "obtainedMark": obtainedMark,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationHr &&
          runtimeType == other.runtimeType &&
          traineeId == other.traineeId;

  @override
  int get hashCode => traineeId.hashCode;
}
