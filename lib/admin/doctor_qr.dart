import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DoctorQRPage extends StatelessWidget {

  final DoctorModel doctor;

  const DoctorQRPage({super.key, required this.doctor});

  Future<void> saveQR() async {

    final qrPainter = QrPainter(
      data: doctor.id,
      version: QrVersions.auto,
      gapless: true,
    );

    final picData = await qrPainter.toImageData(1024);

    final buffer = picData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/doctor_qr.png");

    await file.writeAsBytes(buffer);

    await GallerySaver.saveImage(file.path);
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Doctor QR")),
      persistentFooterButtons: [
        GlobalWidget.contain(w, "Download Now"),
      ],
      body: Center(
        child: QrImageView(
          data: doctor.id,
          size: 260,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          embeddedImage: const AssetImage("assets/logo.jpg"),
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(50, 50),
          ),
        )
      ),
    );
  }
}