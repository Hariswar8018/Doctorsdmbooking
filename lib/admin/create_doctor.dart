import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/doctor_qr.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:flutter/material.dart';

class CreateDoctorPage extends StatefulWidget {

  DoctorModel? doctor ;
  CreateDoctorPage({super.key,this.doctor = null, });

  @override
  State<CreateDoctorPage> createState() => _CreateDoctorPageState();
}

class _CreateDoctorPageState extends State<CreateDoctorPage> {
  final nameC = TextEditingController();

  final depC = TextEditingController();

  final other1C = TextEditingController();

  final other2C = TextEditingController();

  final db = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    if(widget.doctor!=null){
      nameC.text=widget.doctor!.doctorName;
      depC.text=widget.doctor!.department;
      other1C.text=widget.doctor!.other1;
      other2C.text=widget.doctor!.other2;
      setState(() {

      });
    }
  }
  Future<void> createDoctor(BuildContext context) async {
    if(widget.doctor!=null){
      DoctorModel doctor = DoctorModel(
        id: widget.doctor!.id,
        doctorName: nameC.text,
        department: depC.text,
        other1: other1C.text,
        other2: other2C.text,
      );
      await FirebaseFirestore.instance.collection("doctors").doc(widget.doctor!.id).update(doctor.toMap());
      Navigator.pop(context);
      return ;
    }
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
            TextField(controller: other1C, decoration: const InputDecoration(labelText: "Availability Days")),
            TextField(controller: other2C, decoration: const InputDecoration(labelText: "Availability Time ")),
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