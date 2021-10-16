import 'package:documentdownload/display/pdf_view_plugind.dart';
import 'package:documentdownload/download/download_api.dart';
import 'package:documentdownload/download/download_file.dart';
import 'package:documentdownload/dual/display_download_pdf.dart';
import 'package:documentdownload/dual/progress_dis_down.dart';
import 'package:documentdownload/image/display_image.dart';
import 'package:documentdownload/image/image_download.dart';
import 'package:flutter/material.dart';
import 'package:documentdownload/image/image_download_first.dart';
import 'package:documentdownload/documents/passport_file.dart';
import 'package:documentdownload/download/download_first.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ApiDownload(),
    );
  }
}

