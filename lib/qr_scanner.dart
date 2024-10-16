
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRCameraScanner extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _QRCameraScanner();

}

class _QRCameraScanner extends State<QRCameraScanner>
{
  ///Below is the Qr code package init
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  void init()async
  {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      ///Do whatever here if its denied
    }

// You can also directly ask permission about its status.
    if (await Permission.location.isRestricted) {

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const  Text('Qr code scanner'),
        ///Simply using the QR code package widget to make it work
          SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ]


      ),
    );
  }

  ///this function will be called the moment some one will capture the QRCode
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        ///this below will print the code
        print(result!.code??'');
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

}