import 'package:doctorsdmbooking/features/auth/auth.dart';
import 'package:doctorsdmbooking/screens/first/register.dart';
import 'package:doctorsdmbooking/screens/home/navigation.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailC = TextEditingController();
  final passC = TextEditingController();

  final auth = AuthService();

  bool loading = false;

  login() async {

    setState(() => loading = true);

    final user = await auth.loginOrCreate(
      emailC.text.trim(),
      passC.text.trim(),
    );

    if (user == null) return;

    final exists = await auth.userProfileExists(user.uid);

    if (!mounted) return;

    if (exists) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterPage(uid: user.uid)),
      );

    }

    setState(() => loading = false);
  }

  google() async {

    setState(() => loading = true);

    final user = await GoogleAuthService.signIn();

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    final exists = await auth.userProfileExists(user.uid);

    if (!mounted) return;

    if (exists) {
      print(exists);
      print(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterPage(uid: user.uid)),
      );

    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Center(child: Image.asset("assets/logo.jpg",width: 140,)),
            Text("Welcome Back",style: TextStyle(
              fontWeight: FontWeight.w900,fontSize: 24
            ),),
            Text("Sign in to manage your Appointments and manage live Tokens",style: TextStyle(
                fontWeight: FontWeight.w500,fontSize: 17,color: Colors.grey.shade700
            ),),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passC,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            loading?Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: GlobalWidget.color,
              ),
            ):InkWell(
                onTap: login,
                child: GlobalWidget.contain(w,"Login")),
            const SizedBox(height: 10),
            loading?SizedBox():Center(child: Text("OR")),
            const SizedBox(height: 10),
            loading?SizedBox():InkWell(
              onTap: google,
              child: Container(
                width: w,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img.png",width: 20,),
                    SizedBox(width: 15,),
                    Text("Login with Google",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}