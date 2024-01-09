import 'dart:convert';

FeedBack feedBacksFromJson(String str) => FeedBack.fromJson(json.decode(str));

String feedBacksToJson(FeedBack data) => json.encode(data.toJson());

class FeedBack {
  int? id;
  String? trainerId;
  String? trainerName;
  String? message;

  FeedBack({
    this.id,
    this.trainerId,
    this.trainerName,
    this.message,
  });

  factory FeedBack.fromJson(Map<String, dynamic> json) => FeedBack(
    id: json["id"],
    trainerId: json["trainerId"],
    trainerName: json["trainerName"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "trainerId": trainerId,
    "trainerName": trainerName,
    "message": message,
  };
}