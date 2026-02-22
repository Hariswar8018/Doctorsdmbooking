import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> generateTokenForDoctor(
    DoctorModel doctor,
    ) async {

  final db = FirebaseFirestore.instance;

  final user = FirebaseAuth.instance.currentUser!;

  final today = DateTime.now().toString().split(" ").first;

  final ref = db.collection("tokens").doc(today);

  await db.runTransaction((tx) async {

    final snap = await tx.get(ref);

    int counter = snap.exists ? snap["counter"] : 0;

    counter++;

    tx.set(ref, {"counter": counter}, SetOptions(merge: true));

    tx.set(ref.collection("queue").doc(), {
      "token": counter,
      "doctorId": doctor.id,
      "doctorName": doctor.doctorName,
      "userId": user.uid,
      "time": DateTime.now().millisecondsSinceEpoch
    });
  });
}