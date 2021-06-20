import 'package:flutter/material.dart';
import 'package:ios_launcher/home_apps.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/tray_apps.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.categoryApps, required this.openDrawer})
      : super(key: key);
  final List<CategoryApps> categoryApps;
  final Function openDrawer;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: HomeApps(
            apps: widget.categoryApps
                .where((element) => element.categoryName == "SortedAllApp")
                .toList()
                .first,
            openDrawer: () {
              widget.openDrawer();
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: TrayApps(
            trayApps: widget.categoryApps
                .where((element) => element.categoryName == "Tray Apps")
                .toList()
                .first,
          ),
        )
      ],
    );
  }
}
