import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ios_launcher/main.dart';
import 'package:ios_launcher/models/category_app_model.dart';

class TrayApps extends StatefulWidget {
  const TrayApps({Key? key, required this.trayApps}) : super(key: key);
  final CategoryApps trayApps;

  @override
  _TrayAppsState createState() => _TrayAppsState();
}

class _TrayAppsState extends State<TrayApps> {
  late final CategoryApps trayApps;
  late Box box;
  @override
  void initState() {
    box = Hive.box<CategoryApps>('categoryApps');
    trayApps = widget.trayApps;
    trayApps.categoryApps.sort((a, b) {
      return a.index.compareTo(b.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.12,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 22.5),
        decoration: BoxDecoration(
            color: Colors.white30.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: ReorderableListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final items = trayApps.categoryApps.removeAt(oldIndex);
                trayApps.categoryApps.insert(newIndex, items);
                box.put(trayApps.categoryName, trayApps);
              });
            },
            children: <Widget>[
              for (final items in trayApps.categoryApps)
                GestureDetector(
                  key: ValueKey(items),
                  onTap: () async {
                    final Map<String, dynamic> args = <String, dynamic>{};
                    args.putIfAbsent('uri', () => items.appPackage);
                    await platform.invokeMethod("launchApp", args);
                  },
                  child: Container(
                    height: 65,
                    width: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image:
                            DecorationImage(image: MemoryImage(items.appIcon))),
                  ),
                )
            ],
          ),
        ));
  }
}
