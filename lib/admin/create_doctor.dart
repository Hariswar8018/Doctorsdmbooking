import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/doctor_qr.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:flutter/material.dart';

class CreateDoctorPage extends StatelessWidget {

  CreateDoctorPage({super.key});

  final nameC = TextEditingController();
  final depC = TextEditingController();
  final other1C = TextEditingController();
  final other2C = TextEditingController();

  final db = FirebaseFirestore.instance;

  Future<void> createDoctor(BuildContext context) async {

    final ref = db.collection("doctors").doc();

    DoctorModel doctor = DoctorModel(
      id: ref.id,
      doctorName: nameC.text,
      department: depC.text,
      other1: other1C.text,
      other2: other2C.text,
    );

    await ref.set(doctor.toMap());
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorQRPage(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Create Doctor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Doctor Name")),
            TextField(controller: depC, decoration: const InputDecoration(labelText: "Department")),
            TextField(controller: other1C, decoration: const InputDecoration(labelText: "Other1")),
            TextField(controller: other2C, decoration: const InputDecoration(labelText: "Other2")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => createDoctor(context),
              child: const Text("Create & Generate QR"),
            )
          ],
        ),
      ),
    );
  }
}