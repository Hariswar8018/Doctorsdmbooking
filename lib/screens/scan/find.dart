import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:flutter/material.dart';
class Find extends StatefulWidget {
  const Find({super.key});

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
  Future<List<DoctorModel>> searchDoctor(String text) async {

    final snap = await FirebaseFirestore.instance
        .collection("doctors")
        .where("doctorName", isGreaterThanOrEqualTo: text)
        .get();

    return snap.docs
        .map((e) => DoctorModel.fromMap(e.data()))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
