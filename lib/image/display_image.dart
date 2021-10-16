import 'package:flutter/material.dart';

class ImageDisplay extends StatefulWidget {
  const ImageDisplay({Key key}) : super(key: key);

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Tutorial - googleflutter.com'),
      ),
      body: Center(
          child: Column(children: <Widget>[
            Text('Welcome to Flutter Tutorial on Image'),
            Image.network('https://googleflutter.com/sample_image.jpg'),
          ])),
    );
  }
}
