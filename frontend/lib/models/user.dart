import 'dart:convert';

import 'package:file_picker/file_picker.dart';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    int? userId;
    String? role;
    String? email;
    String? contactNo;
    String? dob;
    String? educationalInstitute;
    String? degreeName;
    String? passingYear;
    String? cgpa;
    String? designation;
    String? expertise;
    String? joiningDate;
    String? presentAddress;
    int? profilePictureId;
    String? fullName;
    PlatformFile? file;


    User({
        this.userId,
        this.role,
        this.email,
        this.contactNo,
        this.dob,
        this.educationalInstitute,
        this.degreeName,
        this.passingYear,
        this.cgpa,
        this.designation,
        this.expertise,
        this.joiningDate,
        this.presentAddress,
        this.profilePictureId,
        this.fullName,
        this.file
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        role: json["role"],
        email: json["email"],
        contactNo: json["contactNo"],
        dob: json["dob"] ,
        educationalInstitute: json["educationalInstitute"],
        degreeName: json["degreeName"],
        passingYear: json["passingYear"],
        cgpa: json["cgpa"],
        designation: json["designation"],
        expertise: json["expertise"],
        joiningDate: json["joiningDate"] ,
        presentAddress: json["presentAddress"],
        profilePictureId: json["profilePictureId"],
        fullName: json["fullName"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "role": role,
        "email": email,
        "contactNo": contactNo,
        "dob": dob ,
        "educationalInstitute": educationalInstitute,
        "degreeName": degreeName,
        "passingYear": passingYear,
        "cgpa": cgpa,
        "designation": designation,
        "expertise": expertise,
        "joiningDate": joiningDate ,
        "presentAddress": presentAddress,
        "profilePictureId": profilePictureId,
        "fullName": fullName,
    };

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
    String toString() {
        return 'User{userId: $userId, role: $role, email: $email, contactNo: $contactNo, dob: $dob, educationalInstitute: $educationalInstitute, degreeName: $degreeName, passingYear: $passingYear, cgpa: $cgpa, designation: $designation, expertise: $expertise, joiningDate: $joiningDate, presentAddress: $presentAddress, profilePictureId: $profilePictureId, fullName: $fullName}';
    }
}
