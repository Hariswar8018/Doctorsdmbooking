import 'package:doctorsdmbooking/model/doctor.dart';
import 'package:doctorsdmbooking/widget/global/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class DoctorQRPage extends StatelessWidget {

  final DoctorModel doctor;

   DoctorQRPage({super.key, required this.doctor});

  Future<bool> saveQR() async {
    try {

      RenderRepaintBoundary boundary =
      qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3);

      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      final pngBytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/${doctor.doctorName}_${doctor.department}.png");

      await file.writeAsBytes(pngBytes);

      final result = await GallerySaver.saveImage(file.path);

      return result ?? false;

    } catch (e) {
      print(e);
      return false;
    }
  }

  final GlobalKey qrKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Doctor QR")),
      persistentFooterButtons: [

        Builder(
          builder: (context) {
            return InkWell(
              onTap: () async {

                final success = await saveQR();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? "QR saved to gallery"
                          : "Failed to save QR",
                    ),
                  ),
                );
              },
              child: GlobalWidget.contain(w, "Download Now",on: true),
            );
          },
        ),

      ],
      body: Center(
        child: RepaintBoundary(
          key: qrKey,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: QrImageView(
              data: doctor.id,
              size: 260,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              embeddedImage: const AssetImage("assets/logo.jpg"),
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(50, 50),
              ),
            ),
          ),
        )
      ),
    );
  }
}