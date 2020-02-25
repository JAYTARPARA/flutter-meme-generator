import 'dart:collection';
import 'dart:io';
import 'dart:core';
import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meme_generater/sidebar.dart';
import 'package:image_gallery/image_gallery.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyMemes extends StatefulWidget {
  @override
  _MyMemesState createState() => _MyMemesState();
}

class _MyMemesState extends State<MyMemes> {
  Map<dynamic, dynamic> allImageInfo = new HashMap();
  List allImage = new List();
  List allImageTempMeme = new List();

  Future<void> _getImages() async {
    Map<dynamic, dynamic> allImageTemp;
    allImageTemp = await FlutterGallaryPlugin.getAllImages;
    // print(" call ${allImageTemp.length}");

    for (int i = 0; i < allImageTemp['URIList'].length; i++) {
      if (allImageTemp['URIList'][i]
          .contains('storage/emulated/0/Meme Generator')) {
        this.allImageTempMeme.add(allImageTemp['URIList'][i]);
      }
    }
    // print(allImageTempMeme);

    setState(() {
      this.allImage = allImageTempMeme.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      resizeToAvoidBottomPadding: false,
      drawer: Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('My Memes'),
        centerTitle: true,
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
          elevation: 5.0,
        ),
        child: allImage.length == 0
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Oops!!! There is nothing to show here. Start creating memes and share it.'
                              .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: StaggeredGridView.countBuilder(
                  primary: false,
                  itemCount: allImage.length,
                  crossAxisCount: 4,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  itemBuilder: (context, index) {
                    return _Tile(index, allImage[index].toString());
                  },
                  staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
                ),
              ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.index, this.filePath);

  final int index;
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new Center(
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
                new Text(
                  'Meme ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
