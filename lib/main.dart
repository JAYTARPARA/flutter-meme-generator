import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generater/my_memes.dart';
import 'package:meme_generater/my_memes_copy.dart';
import 'package:meme_generater/sidebar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEME GENERATOR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.black87,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new HomePage(),
        '/my-memes': (BuildContext context) => new MyMemes(),
        '/my-memes-copy': (BuildContext context) => new MyMemesCopy(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey globalKey = new GlobalKey();

  String headerText = "";
  String footerText = "";

  File _image;
  File _imageFile;

  bool imageSelected = false;

  Random rng = new Random();

  bool _isVisible = true;

  final TextEditingController _headerTextController =
      new TextEditingController();
  final TextEditingController _footerTextController =
      new TextEditingController();

  // create some values
  Color headerTextColor = Color(0xFFFFFFFF);
  Color footerTextColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getImage() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (platformException) {
      print("not allowing " + platformException);
    }
    _checkPermission();
    new Directory('storage/emulated/0/' + 'MemeGenerator')
        .create(recursive: true)
        .then((Directory directory) {
      print(directory.path);
    });
    setState(() {
      if (image != null) {
        imageSelected = true;
        createNewMeme('reset');
      } else {}
      _image = image;
    });
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
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Press again to exit'),
          elevation: 5.0,
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  imageSelected
                      ? SizedBox(
                          height: 8.0,
                        )
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/smile.png',
                                height: 80.0,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Image.asset(
                                'assets/images/memegenrator.png',
                                height: 70.0,
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                            ],
                          ),
                        ),
                  RepaintBoundary(
                    key: globalKey,
                    child: Stack(
                      children: <Widget>[
                        _image != null
                            ? Image.file(
                                _image,
                                height: 300,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Container(),
                        _image != null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        headerText.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: headerTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 26.0,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.black87,
                                            ),
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 8.0,
                                              color: Colors.black87,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        footerText.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: footerTextColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 26.0,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.black87,
                                            ),
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 8.0,
                                              color: Colors.black87,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 50.0,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  imageSelected
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: _headerTextController,
                                readOnly: _imageFile == null ? false : true,
                                enableInteractiveSelection: false,
                                onChanged: (value) {
                                  setState(() {
                                    headerText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  labelText: "HEADER TEXT",
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.format_color_text),
                                    color: headerTextColor,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            titlePadding: EdgeInsets.all(0.0),
                                            contentPadding: EdgeInsets.all(0.0),
                                            content: SingleChildScrollView(
                                              child: MaterialPicker(
                                                pickerColor: headerTextColor,
                                                onColorChanged:
                                                    changeHeaderColor,
                                                enableLabel: true,
                                                // colorPickerWidth: 300.0,
                                                // pickerAreaHeightPercent: 0.7,
                                                // enableAlpha: true,
                                                // displayThumbColor: true,
                                                // showLabel: true,
                                                // paletteType: PaletteType.hsv,
                                                // pickerAreaBorderRadius:
                                                //     BorderRadius.only(
                                                //   topLeft: Radius.circular(2.0),
                                                //   topRight: Radius.circular(2.0),
                                                // ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              TextField(
                                controller: _footerTextController,
                                readOnly: _imageFile == null ? false : true,
                                enableInteractiveSelection: false,
                                onChanged: (value) {
                                  setState(() {
                                    footerText = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  labelText: "FOOTER TEXT",
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.format_color_text),
                                    // color: Colors.white,
                                    color: footerTextColor,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            titlePadding: EdgeInsets.all(0.0),
                                            contentPadding: EdgeInsets.all(0.0),
                                            content: SingleChildScrollView(
                                              child: MaterialPicker(
                                                pickerColor: footerTextColor,
                                                onColorChanged:
                                                    changeFooterColor,
                                                enableLabel: true,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              _imageFile == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        RaisedButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            createNewMeme('reset');
                                          },
                                          child: Text(
                                            "RESET MEME",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: () {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            takeScreenshot();
                                          },
                                          child: Text(
                                            "SAVE MEME",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          color: Colors.black,
                                          padding: const EdgeInsets.all(15.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Center(
                            child: Text(
                              "Select image to get started".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                  _imageFile != null
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Divider(
                                height: 25,
                                thickness: 0.5,
                                color: Colors.white.withOpacity(0.3),
                                indent: 15,
                                endIndent: 15,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Text(
                                  'Your meme preview is below and you can check it in My Meme page from sidebar'
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Stack(
                                children: <Widget>[
                                  Image.file(_imageFile),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        createNewMeme('new');
                                      },
                                      child: Text(
                                        "CREATE NEW MEME",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.black,
                                      padding: const EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          "/my-memes",
                                          (r) => false,
                                        );
                                      },
                                      child: Text(
                                        "MY MEMES",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Colors.black,
                                      padding: const EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55.0,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: () {
            getImage();
          },
          child: Icon(Icons.add_a_photo),
        ),
      ),
    );
  }

  Future<void> takeScreenshot() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File('$directory/screenshot${rng.nextInt(200)}.png');
    setState(() {
      _imageFile = imgFile;
    });
    _savefile(_imageFile);
    imgFile.writeAsBytes(pngBytes);
  }

  Future<void> _savefile(File file) async {
    await _askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
  }

  _askPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
      PermissionGroup.photos,
      PermissionGroup.storage,
    ]);
  }

  _checkPermission() async {
    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.requestPermissions([
      Permission.WRITE_EXTERNAL_STORAGE,
    ]);

    if (permission[Permission.WRITE_EXTERNAL_STORAGE] !=
        PermissionState.GRANTED) {
      _askPermission();
    }
  }

  void changeHeaderColor(Color color) {
    setState(() {
      headerTextColor = color;
    });
  }

  void changeFooterColor(Color color) {
    setState(() {
      footerTextColor = color;
    });
  }

  void createNewMeme(String task) {
    setState(() {
      FocusScope.of(context).requestFocus(FocusNode());
      if (task == "new") {
        _image = null;
        _imageFile = null;
        imageSelected = false;
      }
      _headerTextController.clear();
      _footerTextController.clear();
      headerText = "";
      footerText = "";
      headerTextColor = Color(0xFFFFFFFF);
      footerTextColor = Color(0xFFFFFFFF);
    });
  }
}
