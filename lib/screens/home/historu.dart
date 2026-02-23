

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/screens/card/history_card.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final today = DateTime.now().toString().split(" ").first;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Booking History"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("tokens")
              .doc(today)
              .collection("queue")
              .where("userName", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const CircularProgressIndicator();
            }

            if (snap.data!.docs.isEmpty) {
              return Center(child: GlobalWidget.empty(w, "No Booking Exists !"));
            }


            return ListView.builder(
              itemCount:snap.data!.docs.length ,
              itemBuilder: (BuildContext context, int index) {
                final token = TokenModel.fromMap(
                  snap.data!.docs[index].data() as Map<String, dynamic>,
                );
                return HistoryCard(token: token,admin: false,);

              },

            );
          },
        ),
      ),

    );
  }
}
