import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorsdmbooking/features/token/doctor.dart';
import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/model/user.dart';
import 'package:doctorsdmbooking/screens/scan/generate.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key,required this.user});
  final UserModel user;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  final picker = ImagePicker();
  final db = FirebaseFirestore.instance;

  bool processing = false;

  Future<void> handleDoctor(String doctorId) async {

    if (processing) return;

    processing = true;

    final doc = await db.collection("doctors").doc(doctorId).get();

    if (!doc.exists) {
      processing = false;
      return;
    }

    final doctor = DoctorModel.fromMap(doc.data()!);

    processing = false;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GenerateTokenPage(doctor: doctor,user:widget.user),
      ),
    );
  }
  Future<void> scanGallery() async {

    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final inputImage = InputImage.fromFilePath(file.path);

    final scanner = BarcodeScanner();

    final barcodes = await scanner.processImage(inputImage);

    if (barcodes.isEmpty) return;

    final doctorId = barcodes.first.rawValue;

    if (doctorId != null) {
      handleDoctor(doctorId);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: scanGallery),
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          
          final code = barcodeCapture.barcodes.first.rawValue;
      
          if (code != null) {
            handleDoctor(code);
          }
      
        },
      ),
    );
  }
}