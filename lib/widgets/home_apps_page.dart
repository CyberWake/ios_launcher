import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ios_launcher/drag_and_drop_gridview/dev_drag.dart';
import 'package:ios_launcher/models/app_info_model.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/app.dart';

class HomeAppsPage extends StatefulWidget {
  const HomeAppsPage(
      {Key? key, required this.pageApps, required this.categoryName})
      : super(key: key);
  final String categoryName;
  final List<AppInfo> pageApps;

  @override
  _HomeAppsPageState createState() => _HomeAppsPageState();
}

class _HomeAppsPageState extends State<HomeAppsPage> {
  late List<AppInfo> pageApps;
  late Box box;

  @override
  void initState() {
    box = Hive.box<CategoryApps>('categoryApps');
    pageApps = widget.pageApps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DragAndDropGridView(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.98,
          mainAxisSpacing: 10,
          crossAxisSpacing: 5),
      padding: const EdgeInsets.symmetric(horizontal: 22.5),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            App(
              app: pageApps[index],
              size: 60.0,
            ),
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  pageApps[index].appName.split(' ')[0],
                  style: const TextStyle(color: Colors.white),
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
        box.put(
            widget.categoryName,
            CategoryApps(
                categoryApps: pageApps, categoryName: widget.categoryName));
        setState(() {});
      },
    );
  }
}
