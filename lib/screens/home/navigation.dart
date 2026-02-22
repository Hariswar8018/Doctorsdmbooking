


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/admin.dart';
import 'package:doctorsdmbooking/features/auth/auth.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/scan/scan.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final auth = AuthService();

  UserModel? user;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    user = await auth.getUser(uid);

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final today = DateTime.now().toString().split(" ").first;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width:w ,height: 90,
            color: GlobalWidget.color,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.network("https://cdn-icons-png.flaticon.com/512/4042/4042171.png")
                    ),
                  ),
                  SizedBox(width: 8,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome back,",style: TextStyle(        height: 1, fontSize: 13,color: Colors.white),),
                      Text("${user!.name}",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 15,height: 1,color: Colors.white),),
                      SizedBox(height: 7,),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Spacer(),
                  InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (_)=>Admin()));
                      },
                      child: tabcircle(Icon(Icons.notifications_active_rounded),"notify")),
                  SizedBox(width: 8,),
                ],
              ),
            ),
          ),
          Container(
            width: w,
            height: 90,
            color: GlobalWidget.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
              child: Container(
                width: w-30,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 10,),
                      Text("Search Doctors, Appointment, etc...."),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: GlobalWidget.color,
                          borderRadius: BorderRadius.circular(15)
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.calendar_today,size: 20,color: Colors.white,),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          t("Book Appointment"),
          Center(
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ScanPage(user:user!)));
              },
              child: Container(
                width: w-30,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.shade700
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: GlobalWidget.color,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.qr_code_scanner_outlined,size: 30,color: Colors.white,),
                          )),
                      SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("New Token",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                          Text("Scan Qr or Search"),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward,size: 30,color: GlobalWidget.color),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          t("Current Token"),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("tokens")
                .doc(today)
                .collection("queue")
                .where("userName", isEqualTo: user!.id)
                .limit(1)
                .snapshots(),
            builder: (context, snap) {

              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }

              if (snap.data!.docs.isEmpty) {
                return const Text("No token today");
              }

              final token = TokenModel.fromMap(
                  snap.data!.docs.first.data());

              return Center(
                child: Container(
                  width: w-30,height: 140,
                  decoration: BoxDecoration(
                    color: GlobalWidget.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.medical_services,color: Colors.white,),
                                SizedBox(height: 6,),
                                Text(token.doctor.department,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                                Text(token.doctor.doctorName,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 19),),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("TOKEN",style: TextStyle(color: GlobalWidget.color),),
                                  Text(token.tokenNumber.toString(),style: TextStyle(
                                    fontSize: 27,color: GlobalWidget.color,height: 1
                                  ),)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget t(String str)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15),
    child: Text(str,style: TextStyle(
        fontWeight: FontWeight.w900,fontSize: 19
    ),),
  );
  Widget tabcircle(Widget c,String launch)=>CircleAvatar(
    radius: 23,
    backgroundColor: Colors.grey.shade200,
    child: Center(child: c,),
  );
}
