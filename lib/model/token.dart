import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/model/user.dart';

class TokenModel {

  String id;
  int tokenNumber;
  UserModel user;
  String userName;
  DoctorModel doctor;
  int time;
  String status;

  TokenModel({
    required this.id,
    required this.tokenNumber,
    required this.user,
    required this.userName,
    required this.doctor,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "tokenNumber": tokenNumber,
      "user": user.toMap(),   // FIX
      "userName": userName,
      "doctor": doctor.toMap(),
      "time": time,
      "status": status,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      id: map["id"],
      tokenNumber: map["tokenNumber"],
      user: UserModel.fromMap(map["user"]),
      userName: map["userName"],
      doctor: DoctorModel.fromMap(map["doctor"]),
      time: map["time"],
      status: map["status"],
    );
  }
}