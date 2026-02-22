import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final DateTime time;
  const ErrorScreen({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            radius: 80,
            child: Icon(Icons.close,color: Colors.red,size: 55,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              "You already booked Today !",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w900,color: Colors.red),
            ),
          ),
          Center(
            child: Text(
              "You already booked today at\n${time.hour}:${time.minute}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21),
            ),
          ),

        ],
      ),
    );
    return Scaffold(
      body: Center(
        child: Text(
          "You already booked today at\n${time.hour}:${time.minute}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 22,
              color: Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
