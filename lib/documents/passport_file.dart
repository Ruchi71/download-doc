import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class PassportPdf extends StatefulWidget {
  const PassportPdf({Key key}) : super(key: key);

  @override
  _PassportPdfState createState() => _PassportPdfState();
}

class _PassportPdfState extends State<PassportPdf> {

  final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';

  String pdfFlePath;

  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(sampleUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    var dio = Dio();
    return Scaffold(
      appBar: AppBar(
title: Center(child: Text("Documents")),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30,20,0,0),
              child: Text("Passport",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,

              ),),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30,10,30,0),
                  child: ElevatedButton(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5,5,10,5),
                          child: Icon(Icons.picture_as_pdf),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,5,10,5),
                          child: Text("Passport.pdf"),
                        )
                      ],
                    ),
                    onPressed: loadPdf,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(50,10,30,0),
                  child: ElevatedButton(
                    child: Text("download"),
                    onPressed: ()async{
                      String path = await ExtStorage.getExternalStoragePublicDirectory(
                          ExtStorage.DIRECTORY_DOWNLOADS
                      );
                      String fullpath = "$path/newtask.pdf";
                      download2(dio,sampleUrl,fullpath);


                    },
                  ),
                ),
              ],
            ),
            if (pdfFlePath != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,30,20,50),
                  child: Container(
                    child: PdfView(path: pdfFlePath),
                  ),
                ),
              )
            else
              Container(),

          ],
        ),
      ),
    );
  }

  void getPermission()async {
    print("get permission");
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  }

  Future download2(Dio dio, String url, String savepath) async {
    try {
      Response response = await dio.get(url,
        onReceiveProgress: showdownloadprogress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status){
              return status<500;
            }
        ),);
      File file = File(savepath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeByteSync(response.data);
      await raf.close();

    } catch (e){
      print(e);
    }
  }

  void showdownloadprogress(received, total) {
    if(total != -1){
      Text((received/total * 100).toString() + "%");
      print((received/total * 100).toString() + "%");
    } else{
      Text("Downloaded");
    }
  }
}
