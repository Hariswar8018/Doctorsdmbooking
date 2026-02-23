import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/first/splash.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {

  final UserModel user;

  const UpdateScreen({super.key, required this.user});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameC;
  late TextEditingController ageC;
  late TextEditingController phoneC;
  late TextEditingController placeC;

  String? selectedGender;
  String? selectedOccupation;

  bool progress = false;

  void b(bool v) {
    setState(() {
      progress = v;
    });
  }

  @override
  void initState() {
    super.initState();

    nameC = TextEditingController(text: widget.user.name);
    ageC = TextEditingController(text: widget.user.age.toString());
    phoneC = TextEditingController(text: widget.user.phone.toString());
    placeC = TextEditingController(text: widget.user.place);

    selectedGender = widget.user.gender;
    selectedOccupation = widget.user.occupation;
  }

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
        decoration: InputDecoration(
          counterText: "",
          hintText: str,
          prefixIcon: icon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> updateUser() async {

    if (!formKey.currentState!.validate()) return;

    b(true);

    try {

      UserModel updatedUser = UserModel(
        id: widget.user.id,
        name: nameC.text,
        age: int.parse(ageC.text),
        gender: selectedGender!,
        phone: int.parse(phoneC.text),
        occupation: selectedOccupation!,
        place: placeC.text,
        email: widget.user.email,
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(updatedUser.id)
          .update(updatedUser.toMap());

      b(false);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
      );

    } catch (e) {
      b(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Update Profile")),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            const SizedBox(height: 10),

            c(nameC, "Name", const Icon(Icons.person)),

            c(
              ageC,
              "Age",
              const Icon(Icons.calendar_today),
              type: TextInputType.number,
              maxLength: 3,
            ),

            DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.wc),
                border: OutlineInputBorder(),
              ),
              hint: const Text("Select Gender"),
              items: const [
                "Male",
                "Female",
                "Transgender",
                "Other"
              ]
                  .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
                  .toList(),
              validator: (v) => v == null ? "Select gender" : null,
              onChanged: (v) => setState(() => selectedGender = v),
            ),

            c(
              phoneC,
              "Phone Number",
              const Icon(Icons.phone),
              type: TextInputType.number,
              maxLength: 10,
            ),

            DropdownButtonFormField<String>(
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

            c(placeC, "Place", const Icon(Icons.location_pin)),

            const SizedBox(height: 20),

            progress
                ? GlobalWidget.circular()
                : InkWell(
              onTap: updateUser,
              child: GlobalWidget.contain(w, "Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}