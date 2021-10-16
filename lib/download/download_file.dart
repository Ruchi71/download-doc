import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class MyPdf extends StatefulWidget {
  const MyPdf({Key key}) : super(key: key);

  @override
  _MyPdfState createState() => _MyPdfState();
}

class _MyPdfState extends State<MyPdf> {

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
  }
  @override
  Widget build(BuildContext context) {
    final imgurl = "https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf";
    var dio = Dio();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("download"),
          onPressed: ()async{
            String path = await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_DOWNLOADS
            );
            String fullpath = "$path/newtask1.pdf";
            download2(dio,imgurl,fullpath);

          },
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
      print((received/total * 100).toString() + "%");
    }
  }
}
