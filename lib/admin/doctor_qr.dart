import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoctorQRPage extends StatelessWidget {

  final DoctorModel doctor;

  const DoctorQRPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Doctor QR")),
      body: Center(
        child: QrImageView(
          data: doctor.id,
          size: 260,
        ),
      ),
    );
  }
}