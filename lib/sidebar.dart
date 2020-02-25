import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _createHeader(context),
          _createMenu(context),
        ],
      ),
    );
  }
}

Widget _createMenu(context) {
  return Container(
    child: Column(
      children: <Widget>[
        SizedBox(
          height: 25.0,
        ),
        ListTile(
          title: Text(
            'Create Meme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.camera_enhance,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/home') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/home",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        ListTile(
          title: Text(
            'My Memes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          leading: Icon(
            Icons.image,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            String currentPage = ModalRoute.of(context).settings.name;
            if (currentPage != '/my-memes') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/my-memes",
                (r) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}

Widget _createHeader(context) {
  return Container(
    height: 200.0,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/images/sidebar_header.jpg',
          ),
        ),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            CircularProfileAvatar(
              'https://i.ibb.co/HNb99rw/user.png',
              radius: 60,
              cacheImage: true,
              backgroundColor: Colors.transparent,
              borderWidth: 3,
              borderColor: Colors.white,
              elevation: 5.0,
              foregroundColor: Colors.black87.withOpacity(0.5),
              onTap: () {
                print('pressed on icon');
              },
              showInitialTextAbovePicture: true,
            ),
          ],
        ),
      ),
    ),
  );
}
