import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/create_doctor.dart';
import 'package:doctorsdmbooking/admin/doctor_qr.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';

class AllDoctorsPage extends StatelessWidget {
  const AllDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Doctors")),
      floatingActionButton: FloatingActionButton(
          backgroundColor: GlobalWidget.color,
          child: Icon(Icons.add_reaction_sharp,color: Colors.white,),
          onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateDoctorPage()));
      }),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("doctors")
            .snapshots(),
        builder: (context, snap) {

          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snap.data!.docs.length,
            itemBuilder: (context, i) {

              final doctor = DoctorModel.fromMap(
                snap.data!.docs[i].data(),
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorQRPage(doctor: doctor),
                      ),
                    );
                  },
                  child: Container(
                    width: w,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      children: [

                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF6FD),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.medical_services),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              doctor.doctorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),

                            Text(
                              doctor.department,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                                ),
                                title: const Text("Delete ?"),
                                content: const Text("You sure to Delete this Doctor"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false), // Cancel
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection("doctors").doc(doctor.id).delete();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.resolveWith(
                                            (states) => Colors.red,   // your color here
                                      ),
                                    ),
                                    child: const Text("OK",style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              );
                            },
                          );

                        }, icon: Icon(Icons.delete,color: Colors.red,))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}