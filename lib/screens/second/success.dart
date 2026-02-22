import 'package:doctorsdmbooking/api.dart';
import 'package:flutter/material.dart';

import '../../model/booking_model.dart';
import 'package:dio/dio.dart';

class SuccessScreen extends StatefulWidget {
  final BookingModel model; final int token;
  const SuccessScreen({super.key, required this.model,required this.token});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {

  @override
  void initState() {
    super.initState();
    whatsappapi(widget.model);
  }

  void whatsappapi(BookingModel model){
    print("Sending WhatsApp Message to ${model.phone}");

    sendSms(
        model.phone,
        "✅ Booking Confirmed!\n\n"
            "Dear ${widget.model.name},\n"
            "Your token number is: ${widget.token}.\n"
            "Please visit the clinic counter 10 minutes before your turn.\n\n"
            "Thank you."
    );
    sendSms(
        "919730033112",
        "📢 New Booking Alert\n\n"
            "Name: ${widget.model.name}\n"
            "Phone: ${widget.model.phone}\n"
            "Token: ${widget.token}\n"
            "Doctor: ${widget.model.doctorName}"
    );
  }

  Future<void> sendSms(String phone, String message) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        "https://whatssms.in/textmsg.php",
        queryParameters: {
          "appkey": "dfdss",
          "authkey": Api.apikey,
          "to": phone,
          "message": message,
        },
      );

      print("✅ STATUS: ${response.statusCode}");
      print("✅ RESPONSE: ${response.data}");

    } on DioException catch (e) {
      print("🔥 DIO ERROR: ${e.message}");
      print("🔥 RESPONSE: ${e.response?.data}");

    } catch (e) {
      print("🔥 UNKNOWN ERROR: $e");
    }
  }

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
            child: Icon(Icons.verified_sharp,color: Colors.green,size: 55,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              "Booking Successful!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              "You token no is ${widget.token} 🎉. Please check Whatsapp for Confirmation",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21),
            ),
          ),

        ],
      ),
    );
  }
}

