import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/screens/card/history_card.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';

class AllTokensPage extends StatelessWidget {
  const AllTokensPage({super.key});

  @override
  Widget build(BuildContext context) {

    final today = DateTime.now().toString().split(" ").first;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Today Tokens")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("tokens")
              .doc(today)
              .collection("queue")
              .orderBy("tokenNumber")
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
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: HistoryCard(token: token,admin: true,),
                );
              },

            );
          },
        ),
      ),
    );
  }
}