import 'dart:collection';
import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_gallery/image_gallery.dart';

class MyMemesCopy extends StatefulWidget {
  @override
  _MyMemesCopyState createState() => _MyMemesCopyState();
}

class _MyMemesCopyState extends State<MyMemesCopy> {
  Map<dynamic, dynamic> allImageInfo = new HashMap();
  List allImage = new List();
  List allImageTempMeme = new List();

  @override
  void initState() {
    super.initState();
    loadImageList();
  }

  Future<void> loadImageList() async {
    Map<dynamic, dynamic> allImageTemp;
    allImageTemp = await FlutterGallaryPlugin.getAllImages;
    print(" call ${allImageTemp.length}");

    for (int i = 0; i < allImageTemp['URIList'].length; i++) {
      if (allImageTemp['URIList'][i]
          .contains('storage/emulated/0/Meme Generator')) {
        this.allImageTempMeme.add(allImageTemp['URIList'][i]);
      }
    }
    print(allImageTempMeme);

    setState(() {
      this.allImage = allImageTempMeme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Image Gallery'),
        ),
        body: _buildGrid(),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.extent(
      maxCrossAxisExtent: 150.0,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _buildGridTileList(allImage.length),
    );
  }

  List<Container> _buildGridTileList(int count) {
    return List<Container>.generate(
      count,
      (int index) => Container(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.file(
              File(allImage[index].toString()),
              width: 96.0,
              height: 96.0,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
