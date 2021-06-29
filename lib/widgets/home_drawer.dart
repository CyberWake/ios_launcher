import 'package:flutter/material.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/screens/home_apps.dart';
import 'package:ios_launcher/widgets/tray_apps.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key, required this.categoryApps}) : super(key: key);
  final List<CategoryApps> categoryApps;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          child: HomePageApps(
            apps: widget.categoryApps
                .where((element) => element.categoryName == "SortedAllApp")
                .toList()
                .first,
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
