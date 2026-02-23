


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/admin/admin.dart';
import 'package:doctorsdmbooking/features/auth/auth.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/card/history_card.dart';
import 'package:doctorsdmbooking/screens/first/splash.dart';
import 'package:doctorsdmbooking/screens/home/historu.dart';
import 'package:doctorsdmbooking/screens/home/profile.dart';
import 'package:doctorsdmbooking/screens/scan/find.dart';
import 'package:doctorsdmbooking/screens/scan/scan.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  bool timeout = false;
  load() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    Future.delayed(const Duration(seconds: 8), () {
      if (user == null && mounted) {
        setState(() {
          timeout = true;
        });
      }
    });

    try {
      user = await auth.getUser(uid);
    } catch (e) {
      print(e);
    }

    if (mounted) setState(() {});
  }
  int index = 0;


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    if (user == null) {
      if (timeout) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network("https://uxwing.com/wp-content/themes/uxwing/download/signs-and-symbols/error-icon.png",width: 100,),
                const SizedBox(height: 20),

                const Text("Unable to load account. Do Relogin to Try Again",style: TextStyle(
                  fontWeight: FontWeight.w800
                ),),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {

                    await FirebaseAuth.instance.signOut();

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SplashScreen(),
                      ),
                    );
                  },
                  child: GlobalWidget.contain(w, "Log Out"),
                )
              ],
            ),
          ),
        );
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    String email = FirebaseAuth.instance.currentUser!.email!;
    return (email=="jissmohan.s@gmail.com")||(email=="samasihariswar@gmail.com")?Admin():WillPopScope(
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
        backgroundColor: Colors.white,
        body: returnw(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },

          type: BottomNavigationBarType.fixed,

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: "Scan",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
  Widget returnw(){
    if(index ==0){
      return column();
    }else if (index==1){
      return ScanPage(user: user!);
    }else if (index==2){
      return History();
    }else {
      return Proifile(user: user!,);
    }
  }

  Widget column(){
    final today = DateTime.now().toString().split(" ").first;
    double w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
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
                  SizedBox()
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>Find(user:user!)));
            },
            child: Container(
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
                return GlobalWidget.empty(w, "No Booking Exists !");
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
          SizedBox(height: 20,),
          t("My History"),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("tokens")
                .doc(today)
                .collection("queue")
                .where("userName", isEqualTo: user!.id)
                .snapshots(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const CircularProgressIndicator();
              }

              if (snap.data!.docs.isEmpty) {
                return GlobalWidget.empty(w, "No History Exists !");
              }

              final token = TokenModel.fromMap(
                  snap.data!.docs.first.data());

              return HistoryCard(token: token,admin: false,);
            },
          ),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
  String times(int str){
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
  }
  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  String time(int str){
    final formattedDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch(str));
    return formattedDate;
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
