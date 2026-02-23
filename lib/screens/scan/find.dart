import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/scan/generate.dart';
import 'package:flutter/material.dart';

class Find extends StatefulWidget {
  const Find({super.key, required this.user});
  final UserModel user;

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {

  final searchC = TextEditingController();

  List<DoctorModel> doctors = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {

    final snap = await FirebaseFirestore.instance
        .collection("doctors")
        .orderBy("doctorName")
        .get();

    doctors = snap.docs
        .map((e) => DoctorModel.fromMap(e.data()))
        .toList();

    setState(() {
      loading = false;
    });
  }

  List<DoctorModel> get filtered {

    if (searchC.text.trim().isEmpty) {
      return doctors;
    }

    final q = searchC.text.toLowerCase();

    return doctors.where((d) {

      return d.doctorName.toLowerCase().contains(q) ||
          d.department.toLowerCase().contains(q);

    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        title: TextField(
          controller: searchC,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: "Search doctor or department",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white)
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
          ? const Center(child: Text("No doctors found"))
          : ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final doctor = filtered[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GenerateTokenPage(doctor: doctor,user:widget.user),
                  ),
                );
              },
              child: Container(
                width: w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(9)
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Color(0xffEDF6FD),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Icon(Icons.medical_services),
                    ),
                    SizedBox(width: 12,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctor.doctorName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16),),
                        Text(doctor.department,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}