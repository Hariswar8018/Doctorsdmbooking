import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/create_doctor.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toString().split(" ").first;

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateDoctorPage()));
      }),
      appBar: AppBar(title: const Text("Today Tokens")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("tokens")
            .doc(today)
            .collection("queue")
            .orderBy("tokenNumber", descending: true)
            .snapshots(),
        builder: (context, snap) {

          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {

              final token = TokenModel.fromMap(docs[i].data());

              return ListTile(
                title: Text("Token ${token.tokenNumber}"),
                subtitle: Text(token.doctor.doctorName),
                trailing: ElevatedButton(
                  onPressed: () {

                    docs[i].reference.update({
                      "status": "completed"
                    });

                  },
                  child: const Text("Complete"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
