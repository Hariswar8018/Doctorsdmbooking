import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/create_doctor.dart';
import 'package:doctorsdmbooking/admin/screen/doctor.dart';
import 'package:doctorsdmbooking/admin/screen/token.dart';
import 'package:doctorsdmbooking/admin/screen/user.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/screens/card/history_card.dart';
import 'package:doctorsdmbooking/screens/first/splash.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  int totalTokens = 0;
  int totalDoctors = 0;
  int totalUsers = 0;

  bool loadingStats = true;
  @override
  void initState() {
    super.initState();
    loadStats();
  }
  Future<void> loadStats() async {

    final today = DateTime.now().toString().split(" ").first;

    final tokenSnap = await FirebaseFirestore.instance
        .collection("tokens")
        .doc(today)
        .collection("queue")
        .get();

    final doctorSnap = await FirebaseFirestore.instance
        .collection("doctors")
        .get();

    final userSnap = await FirebaseFirestore.instance
        .collection("users")
        .get();

    setState(() {
      totalTokens = tokenSnap.docs.length;
      totalDoctors = doctorSnap.docs.length;
      totalUsers = userSnap.docs.length;
      loadingStats = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toString().split(" ").first;
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              title: const Text("Close the App ?"),
              content: const Text("You sure to Close the App"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
        return shouldExit ?? false;
      },

      child: Scaffold(

        appBar: AppBar(title: const Text("Admin Tokens"),
        actions: [
          IconButton(onPressed: (){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                  ),
                  title: const Text("Log out ?"),
                  content: const Text("You sure to Log out from the App"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // Cancel
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SplashScreen(),
                          ),
                        );
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
          }, icon: Icon(Icons.login,color: Colors.red,)),
          SizedBox(width: 10,)
        ],),
        body: Column(
          children: [
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllTokensPage()),
                    );
                  },
                  child: srr(
                    "Tokens Today",
                    w,
                    Colors.orangeAccent.shade100,
                    totalTokens,
                        today,
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllDoctorsPage()),
                    );
                  },
                  child: srr(
                    "Doctors",
                    w,
                    Colors.blue.shade100,
                    totalDoctors,
                        today,
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllUsersPage()),
                    );
                  },
                  child: srr(
                    "Users",
                    w,
                    Colors.green.shade100,
                    totalUsers,
                        today,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("tokens")
                    .doc(today)
                    .collection("queue")
                    .orderBy("tokenNumber", descending: true)
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
          ],
        ),
      ),
    );
  }
  Widget srr(String str,double w,Color color,int i,String launch){
    return Container(
      width:w/3-10 ,
      height: 80,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(str,style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 10),),
          Text("$i",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black,fontSize: 16),),
        ],
      ),
    );
  }
}
