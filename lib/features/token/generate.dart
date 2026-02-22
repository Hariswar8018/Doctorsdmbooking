import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/model/user.dart';

Future<int> generateToken(
    UserModel user,
    DoctorModel doctor,
    ) async {

  final db = FirebaseFirestore.instance;

  final today = DateTime.now().toString().split(" ").first;

  final dayRef = db.collection("tokens").doc(today);

  return db.runTransaction((tx) async {

    final snap = await tx.get(dayRef);

    int counter = 0;

    if (snap.exists) {
      counter = snap["counter"];
    }

    counter++;

    tx.set(dayRef, {
      "counter": counter
    }, SetOptions(merge: true));

    final token = TokenModel(
      tokenNumber: counter,
      userId: user.id,
      userName: user.name,
      doctor: doctor,
      time: DateTime.now().millisecondsSinceEpoch,
    );

    tx.set(
      dayRef.collection("queue").doc(),
      token.toMap(),
    );

    return counter;
  });
}