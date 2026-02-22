import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/screens/second/success.dart';
import 'package:flutter/material.dart';

import '../../model/booking_model.dart';
import '../second/error.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final nameC = TextEditingController();
  final ageC = TextEditingController();
  final sexC = TextEditingController();
  final phoneC = TextEditingController();
  final occupationC = TextEditingController();
  final doctorC = TextEditingController();

  Widget c(TextEditingController c, String str, Widget icon,
      {String? Function(String?)? validator,
        TextInputType? type,
        int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLength: maxLength,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          counterText: "",
          hintText: str,
          prefixIcon: icon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }


  String getTodayId() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }
  bool progress = false;

  void b(bool v){
    setState(() {
      progress = v;
    });
  }
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    b(true);

    try {
      String today = getTodayId();
      String phone = "91${phoneC.text.trim()}";

      final todayRef =
      FirebaseFirestore.instance.collection("bookings").doc(today);

      final phoneRef = todayRef
          .collection("phoneNumber")
          .doc(phone);

      await FirebaseFirestore.instance.runTransaction((transaction) async {

        final todaySnap = await transaction.get(todayRef);
        final phoneSnap = await transaction.get(phoneRef);

        if (phoneSnap.exists) {
          b(false);
          final Timestamp ts = phoneSnap["time"];
          final DateTime bookedTime = ts.toDate();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ErrorScreen(time:bookedTime),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Already booked today"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          throw Exception("Already booked today");
        }

        int currentToken = 0;

        if (todaySnap.exists) {
          currentToken = todaySnap["currentToken"] ?? 0;
        }

        if (currentToken >= 100) {
          b(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("All 100 tokens finished for today"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          throw Exception("All 100 tokens finished for today");
          return ;
        }

        int newToken = currentToken + 1;
        transaction.set(todayRef, {
          "currentToken": newToken,
        }, SetOptions(merge: true));

        // Create booking
        BookingModel model = BookingModel(
          name: nameC.text.trim(),
          age: ageC.text.trim(),
          sex: selectedGender!,
          occupation: selectedOccupation!,
          phone: phone,
          doctorName: doctorC.text.trim(),
          tokens: newToken,
          time: DateTime.now(),
        );

        transaction.set(phoneRef, model.toMap());
        b(false);
      });

    } catch (e) {
      b(false);

      print("🔥 ERROR: $e");


    }
  }

  String? selectedGender;
  String? selectedOccupation;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: h,width:w,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/baxkground.png"),fit: BoxFit.cover,opacity: 0.3)
        ),
        child: Center(
          child: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.asset("assets/logo.jpg",height: 180,),
                    Container(
                      width: w-40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                            spreadRadius: 1, // Extends the shadow
                            blurRadius: 1, // Softens the shadow
                            offset: const Offset(0, 2), // Horizontal and vertical offset
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                        child: Column(
                          children: [
                            c(nameC, "Name", const Icon(Icons.person)),
                            c(
                              ageC,
                              "Age",
                              const Icon(Icons.calendar_today),
                              type: TextInputType.number,
                              maxLength: 3,
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Enter age";

                                if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                                  return "Only numbers allowed";
                                }

                                int age = int.parse(v);

                                if (age <= 0) return "Invalid age";
                                if (age > 120) return "Age must be below 120";

                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.wc),
                                  border: OutlineInputBorder(),
                                ),
                                hint: const Text("Select Gender"),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Male",
                                    child: Row(children: [
                                      Icon(Icons.male),
                                      SizedBox(width: 10),
                                      Text("Male")
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "Female",
                                    child: Row(children: [
                                      Icon(Icons.female),
                                      SizedBox(width: 10),
                                      Text("Female")
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "Transgender",
                                    child: Row(children: [
                                      Icon(Icons.transgender),
                                      SizedBox(width: 10),
                                      Text("Transgender")
                                    ]),
                                  ),
                                  DropdownMenuItem(
                                    value: "Other",
                                    child: Row(children: [
                                      Icon(Icons.person_outline),
                                      SizedBox(width: 10),
                                      Text("Other")
                                    ]),
                                  ),
                                ],
                                validator: (v) => v == null ? "Select gender" : null,
                                onChanged: (v) => setState(() => selectedGender = v),
                              ),
                            ),
                            c(
                              phoneC,
                              "Phone Number",
                              const Icon(Icons.phone),
                              type: TextInputType.number,
                              maxLength: 10,
                              validator: (v) {
                                if (v == null || v.isEmpty) return "Enter phone number";
                                if (v.length != 10) return "Phone must be 10 digits";
                                if (!RegExp(r'^[0-9]+$').hasMatch(v)) return "Only digits allowed";
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: DropdownButtonFormField<String>(
                                value: selectedOccupation,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.work),
                                  border: OutlineInputBorder(),
                                ),
                                hint: const Text("Select Occupation"),
                                items: const [
                                  "Student",
                                  "Private Employee",
                                  "Government Employee",
                                  "Business",
                                  "Self Employed",
                                  "Doctor",
                                  "Engineer",
                                  "Teacher",
                                  "Farmer",
                                  "Other"
                                ]
                                    .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                                    .toList(),
                                validator: (v) => v == null ? "Select occupation" : null,
                                onChanged: (v) => setState(() => selectedOccupation = v),
                              ),
                            ),

                            c(doctorC, "Doctor Name", const Icon(Icons.local_hospital)),
                            const SizedBox(height: 20),
                            progress?Center(child: CircularProgressIndicator(
                              color: Colors.black,
                            )):InkWell(
                              onTap: submit,
                              child: Container(
                                width: w-20,
                                height: 55,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                        spreadRadius: 1, // Extends the shadow
                                        blurRadius: 1, // Softens the shadow
                                        offset: const Offset(0, 2), // Horizontal and vertical offset
                                      ),
                                    ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.verified_sharp,color: Colors.black,),
                                    SizedBox(width: 10,),
                                    Text("Submit Details",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 19),),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
