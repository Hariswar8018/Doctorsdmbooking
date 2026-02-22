import 'package:doctorsdmbooking/features/auth/auth.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/home/navigation.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {

  final String uid;

  const RegisterPage({super.key, required this.uid});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
  String? selectedGender;
  String? selectedOccupation;

  final formKey = GlobalKey<FormState>();

  final auth = AuthService();
  TextEditingController place = TextEditingController();
  submit() async {
    if (!formKey.currentState!.validate()) return;
    b(true);
    try {
      UserModel user = UserModel(
        id: widget.uid,
        name: nameC.text,
        age: int.parse(ageC.text),
        gender: selectedGender!,
        phone: int.parse(phoneC.text),
        occupation: selectedOccupation!,
        place: place.text,
        email: FirebaseAuth.instance.currentUser!.email!,
      );

      await auth.createProfile(user);
      b(false);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }catch(e){
      b(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: const Text("Complete Profile")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 68,
                backgroundColor: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade300,
                        child: Center(child: Icon(Icons.person,color: Colors.black,size: 60,),),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25,),
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

            c(place, "Place Name", const Icon(Icons.location_pin)),
            const SizedBox(height: 20),

            progress?GlobalWidget.circular():InkWell(
                onTap: submit,
                child: GlobalWidget.contain(w, "Continue")),
          ],
        ),
      ),
    );
  }
}