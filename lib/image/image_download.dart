import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ImageDownload extends StatefulWidget {
  const ImageDownload({Key key}) : super(key: key);

  @override
  _ImageDownloadState createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownload> {

  File _displayImage;

  final _url =
      '';
  Future<void> _download() async {
    final response = await http.get(Uri.parse(_url));

    // Get the image name
    final imageName = path.basename(_url);
    // Get the document directory path
    final appDir = await pathProvider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later.
    final localPath = path.join(appDir.path, imageName);

    // Downloading
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response.bodyBytes);

    setState(() {
      _displayImage = imageFile;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              ElevatedButton(onPressed: _download, child: Text('Download Image')),
              SizedBox(height: 25),
              _displayImage != null ? Image.file(_displayImage) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
