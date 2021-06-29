import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_launcher/screens/settings/home_page_app_settings.dart';

class LauncherSettings extends StatelessWidget {
  final List<Map<String, dynamic>> tileData = [
    {
      'icon': const Icon(CupertinoIcons.home),
      'title': 'Apps to show on home page'
    },
    {
      'icon': const Icon(CupertinoIcons.tray),
      'title': 'Apps to show on home page'
    },
    {
      'icon': const Icon(CupertinoIcons.sidebar_right),
      'title': 'Organise app drawer'
    },
    // {'icon': const Icon(CupertinoIcons.square_favorites), 'title': ''},
  ];

  navigateTo(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => const HomePageAppSettings()));
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launcher Settings'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tileData.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              navigateTo(index, context);
            },
            leading: tileData[index]['icon'] as Icon,
            title: Text(tileData[index]['title'].toString()),
          );
        },
      ),
    );
  }
}
