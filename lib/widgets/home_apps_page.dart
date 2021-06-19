import 'package:flutter/material.dart';
import 'package:ios_launcher/drag_and_drop_gridview/dev_drag.dart';
import 'package:ios_launcher/models/app_info_model.dart';

import 'app.dart';

class HomeAppsPage extends StatefulWidget {
  const HomeAppsPage({Key? key, required this.pageApps}) : super(key: key);
  final List<AppInfo> pageApps;

  @override
  _HomeAppsPageState createState() => _HomeAppsPageState();
}

class _HomeAppsPageState extends State<HomeAppsPage> {
  late List<AppInfo> pageApps;

  @override
  void initState() {
    pageApps = widget.pageApps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropGridView(
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.5),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            App(
              app: pageApps[index],
              size: 65.0,
            ),
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  pageApps[index].appName.split(' ')[0],
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        );
      },
      itemCount: pageApps.length,
      onWillAccept: (oldIndex, newIndex) {
        print('here');
        return true;
      },
      onReorder: (oldIndex, newIndex) {
        final _temp = pageApps[newIndex];
        pageApps[newIndex] = pageApps[oldIndex];
        pageApps[oldIndex] = _temp;
        setState(() {});
      },
    );
  }
}
