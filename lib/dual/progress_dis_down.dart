import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class ProgressDis extends StatefulWidget {
  const ProgressDis({Key key}) : super(key: key);

  @override
  _ProgressDisState createState() => _ProgressDisState();
}

class _ProgressDisState extends State<ProgressDis> {

  final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';

  String pdfFlePath;
  bool downloading = false;
  var progressString = "";

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
      body: Column(
        children: [
          SizedBox(height: 40,),
          ElevatedButton(
            child: Text("Load pdf"),
            onPressed: loadPdf,
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            child: Text("download"),
            onPressed: ()async{
              String path = await ExtStorage.getExternalStoragePublicDirectory(
                  ExtStorage.DIRECTORY_DOWNLOADS
              );
              String fullpath = "$path/newtask.pdf";
              download2(dio,sampleUrl,fullpath);

            },
          ),
          if (pdfFlePath != null)
            Expanded(
              child: Container(
                child: PdfView(path: pdfFlePath),
              ),
            )
          else
            Text(""),

          Center(
            child: downloading
                ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Downloading File: $progressString",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
                : Text(""),
          ),
          progressString == "100.0%"? Text("Completed"): Text("")

        ],
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
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  void showdownloadprogress(received, total) {
    if(total != -1){
      print((received/total * 100).toString() + "%");
      setState(() {
        downloading = true;
        progressString = ((received / total) * 100).toStringAsFixed(0) + "%";
      });
    } else{
    }
  }
}
