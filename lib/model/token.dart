import 'package:doctorsdmbooking/model/doctor.dart';

class TokenModel {

  int tokenNumber;
  String userId;
  String userName;
  DoctorModel doctor;
  int time;

  TokenModel({
    required this.tokenNumber,
    required this.userId,
    required this.userName,
    required this.doctor,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "tokenNumber": tokenNumber,
      "userId": userId,
      "userName": userName,
      "time": time,
      "doctor": doctor.toMap(),
    };
  }
}