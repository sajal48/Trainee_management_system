
import 'dart:convert';

List<EvaluationFinal> evaluationFinalFromJson(String str) => List<EvaluationFinal>.from(json.decode(str).map((x) => EvaluationFinal.fromJson(x)));

String evaluationFinalToJson(List<EvaluationFinal> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EvaluationFinal {
  int? id;
  int? batchId;
  double? srs;
  double? wbs;
  double? designDocument;
  double? ppt;
  int? traineeId;
  int? evaluatorId;
  String? evaluatedOn;
  double? totalMark;
  double? obtainedMark;
  double? requirementUnderstanding;
  double? expectedOutput;
  double? codeQuality;
  double? demonstrationOrPresentation;
  double? liveCodingOrCodeUnderstanding;

  EvaluationFinal({
    this.id,
    this.batchId,
    this.srs,
    this.wbs,
    this.designDocument,
    this.ppt,
    this.traineeId,
    this.evaluatorId,
    this.evaluatedOn,
    this.totalMark,
    this.obtainedMark,
    this.requirementUnderstanding,
    this.expectedOutput,
    this.codeQuality,
    this.demonstrationOrPresentation,
    this.liveCodingOrCodeUnderstanding,
  });

  void setObtainedMarkIfNull(EvaluationFinal evaluationFinal) {

      // Calculate the sum of non-null marks and assign it to the obtainedMark field
      double sum = 0.0;
      if (evaluationFinal.srs != null) sum += evaluationFinal.srs!;
      if (evaluationFinal.wbs != null) sum += evaluationFinal.wbs!;
      if (evaluationFinal.designDocument != null) sum += evaluationFinal.designDocument!;
      if (ppt != null) sum += ppt!;
      if (evaluationFinal.requirementUnderstanding != null) sum += evaluationFinal.requirementUnderstanding!;
      if (evaluationFinal.expectedOutput != null) sum += evaluationFinal.expectedOutput!;
      if (evaluationFinal.codeQuality != null) sum += evaluationFinal.codeQuality!;
      if (evaluationFinal.demonstrationOrPresentation != null) sum += evaluationFinal.demonstrationOrPresentation!;
      if (evaluationFinal.liveCodingOrCodeUnderstanding != null) sum += evaluationFinal.liveCodingOrCodeUnderstanding!;

      obtainedMark = sum;

  }

  factory EvaluationFinal.fromJson(Map<String, dynamic> json) => EvaluationFinal(
    id: json["id"],
    batchId: json["batchId"],
    srs: json["srs"]?.toDouble(),
    wbs: json["wbs"]?.toDouble(),
    designDocument: json["designDocument"]?.toDouble(),
    ppt: json["ppt"],
    traineeId: json["traineeId"],
    evaluatorId: json["evaluatorId"],
    evaluatedOn: json["evaluatedOn"],
    totalMark: json["totalMark"]?.toDouble(),
    obtainedMark: json["obtainedMark"]?.toDouble(),
    requirementUnderstanding: json["requirementUnderstanding"],
    expectedOutput: json["expectedOutput"]?.toDouble(),
    codeQuality: json["codeQuality"],
    demonstrationOrPresentation: json["demonstrationOrPresentation"]?.toDouble(),
    liveCodingOrCodeUnderstanding: json["liveCodingOrCodeUnderstanding"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batchId": batchId,
    "srs": srs,
    "wbs": wbs,
    "designDocument": designDocument,
    "ppt": ppt,
    "traineeId": traineeId,
    "evaluatorId": evaluatorId,
    "evaluatedOn": evaluatedOn,
    "totalMark": totalMark,
    "obtainedMark": obtainedMark,
    "requirementUnderstanding": requirementUnderstanding,
    "expectedOutput": expectedOutput,
    "codeQuality": codeQuality,
    "demonstrationOrPresentation": demonstrationOrPresentation,
    "liveCodingOrCodeUnderstanding": liveCodingOrCodeUnderstanding,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationFinal &&
          runtimeType == other.runtimeType &&
          traineeId == other.traineeId;

  @override
  int get hashCode => traineeId.hashCode;
}