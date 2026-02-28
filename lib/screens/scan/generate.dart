import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/model/token.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GenerateTokenPage extends StatefulWidget {
  final UserModel user;
  final DoctorModel doctor;

  const GenerateTokenPage({super.key, required this.doctor,required this.user});

  @override
  State<GenerateTokenPage> createState() => _GenerateTokenPageState();
}

class _GenerateTokenPageState extends State<GenerateTokenPage> {

  bool loading = false;

  final db = FirebaseFirestore.instance;

  late TextEditingController nameC;
  late TextEditingController ageC;
  late TextEditingController genderC;
  late TextEditingController phoneC;
  late TextEditingController occupationC;
  late TextEditingController placeC;
  late TextEditingController emailC;

  late TextEditingController doctor;
  late TextEditingController dep;

  @override
  void initState() {
    super.initState();
    doctor = TextEditingController(text: widget.doctor.doctorName);
    dep = TextEditingController(text: widget.doctor.department);
    nameC = TextEditingController(text: widget.user.name);
    ageC = TextEditingController(text: widget.user.age.toString());
    genderC = TextEditingController(text: widget.user.gender);
    phoneC = TextEditingController(text: widget.user.phone.toString());
    occupationC = TextEditingController(text: widget.user.occupation);
    placeC = TextEditingController(text: widget.user.place);
    emailC = TextEditingController(text: widget.user.email);
    selectedGender = genderC.text;
    selectedOccupation = occupationC.text;
  }
  final formKey = GlobalKey<FormState>();
  late String? selectedGender;
  late String? selectedOccupation;

  final FlutterLocalNotificationsPlugin notifications =
  FlutterLocalNotificationsPlugin();
  Future<void> showNotification(int counter) async {

    const android = AndroidNotificationDetails(
      'token_channel',
      'Token Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: android);

    await notifications.show(
      id: 0,
      title: 'Token no $counter Generated for you',
        body: 'Your appointment token has been created with no $counter. Please go to the counter 10 minutes before Token Number',
      notificationDetails: details
    );
  }
  Future<void> createToken() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final authUser = FirebaseAuth.instance.currentUser!;

    final today = DateTime.now().toString().split(" ").first;

    final dayRef = db.collection("tokens").doc(today);

    /// prevent multiple tokens per day
    final existing = await dayRef
        .collection("queue")
        .where("userName", isEqualTo: authUser.uid)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token already generated today")),
      );

      setState(() => loading = false);
      return;
    }

    UserModel updatedUser = UserModel(
      id: authUser.uid,
      name: nameC.text,
      age: int.tryParse(ageC.text) ?? 0,
      gender: genderC.text,
      phone: int.tryParse(phoneC.text) ?? 0,
      occupation: occupationC.text,
      place: placeC.text,
      email: emailC.text,
    );

    await db.runTransaction((tx) async {

      final snap = await tx.get(dayRef);

      int counter = snap.exists ? snap["counter"] : 0;

      counter++;

      tx.set(dayRef, {"counter": counter}, SetOptions(merge: true));

      final tokenRef = dayRef.collection("queue").doc();

      TokenModel token = TokenModel(
        id: tokenRef.id,
        tokenNumber: counter,
        user: updatedUser,
        userName: updatedUser.id,
        doctor: widget.doctor,
        time: DateTime.now().millisecondsSinceEpoch,
        status: "pending",
      );

      tx.set(tokenRef, token.toMap());
      showNotification(counter);
      tx.set(
        db.collection("users").doc(updatedUser.id),
        updatedUser.toMap(),
        SetOptions(merge: true),
      );
    });

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Generate Token")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            (widget.doctor.other1.isNotEmpty||widget.doctor.other2.isNotEmpty)?Container(
              color: Colors.yellow,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please Check Doctor Availability Below : ",
                        style: const TextStyle(
                            fontSize: 14,fontWeight: FontWeight.w900
                        ),
                      ),
                      widget.doctor.other1.isEmpty?SizedBox():Text(
                        "Days Avaialble : "+widget.doctor.other1,
                        style: const TextStyle(
                            fontSize: 10,fontWeight: FontWeight.w900
                        ),
                      ),
                      widget.doctor.other2.isEmpty?SizedBox():Text(
                        "Time : "+widget.doctor.other2,
                        style: const TextStyle(
                            fontSize: 10,fontWeight: FontWeight.w900
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ):SizedBox(),
            c(dep, "Name", const Icon(Icons.medical_services_sharp),on: false),
            c(doctor, "Name", const Icon(Icons.medical_information_rounded),on: false),
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

            c(placeC, "Place Name", const Icon(Icons.location_pin)),
            const SizedBox(height: 20),

            progress?GlobalWidget.circular():InkWell(
                onTap: createToken,
                child: GlobalWidget.contain(w, "Generate Token")),
          ],
        ),
      ),
    );
  }
  bool progress = false;
  Widget c(TextEditingController c, String str, Widget icon,
      {String? Function(String?)? validator,
        TextInputType? type,
        bool on = true,
        int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLength: maxLength,
        readOnly: !on,
        validator: validator,
        style: const TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          enabled: on,
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
}