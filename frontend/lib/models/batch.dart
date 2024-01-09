import 'dart:convert';

import 'package:front/models/user.dart';

List<Batch> batchFromJson(String str) =>
    List<Batch>.from(json.decode(str).map((x) => Batch.fromJson(x)));

String batchToJson(List<Batch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Batch {
  int? id;
  String? description;
  String? batchName;
  String? startDate;
  String? endDate;
  bool? status;
  List<User>? trainees;
  List<int?>? userIds;

  Batch(
      {this.id,
      this.description,
      this.batchName,
      this.startDate,
      this.endDate,
      this.status,
      this.trainees,
      List<int?>? userIds});

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
        id: json["id"],
        description: json["description"],
        batchName: json["batchName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        trainees: json["trainees"] != null
            ? List<User>.from(json["trainees"].map((x) => User.fromJson(x)))
            : null,
        userIds: json["userIds"] != null
            ? List<int?>.from(json["userIds"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "batchName": batchName,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "trainees": trainees != null
            ? List<dynamic>.from(trainees!.map((x) => x.toJson()))
            : null,
        "userIds":
            userIds != null ? List<dynamic>.from(userIds!.map((x) => x)) : null,
      };

  @override
  String toString() {
    return 'Batch{id: $id, description: $description, batchName: $batchName, startDate: $startDate, endDate: $endDate, status: $status, trainees: $trainees, userIds: $userIds}';
  }
}
