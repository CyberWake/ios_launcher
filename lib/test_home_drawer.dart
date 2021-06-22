import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:ios_launcher/drag_and_drop_gridview/dev_drag.dart';
import 'package:ios_launcher/models/app_info_model.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/app.dart';

class TestHomeDrawer extends StatefulWidget {
  const TestHomeDrawer({Key? key, required this.apps}) : super(key: key);
  final CategoryApps apps;

  @override
  _TestHomeDrawerState createState() => _TestHomeDrawerState();
}

class _TestHomeDrawerState extends State<TestHomeDrawer> {
  final ScrollController controller = ScrollController();
  late final CategoryApps apps;
  late Box box;
  int page = 0;
  bool scrollFromDot = false;
  final implicitScroll = ValueNotifier<bool>(false);

  @override
  void initState() {
    apps = widget.apps;
    if (apps.categoryApps.length % 24 != 0) {
      final int emptyApps = 24 - apps.categoryApps.length % 24;
      print(emptyApps);
      for (int i = 0; i < emptyApps; i++) {
        apps.categoryApps.add(AppInfo(
            appName: '',
            appPackage: '',
            appIcon: Uint8List(0),
            appCategory: '',
            index: -1));
      }
    }
    box = Hive.box<CategoryApps>('categoryApps');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 15.0, bottom: MediaQuery.of(context).size.height * 0.135),
      child: Column(
        children: [
          Expanded(
            child: NotificationListener(
              onNotification: (notificationInfo) {
                if (notificationInfo is ScrollUpdateNotification) {
                  if (controller.position.userScrollDirection ==
                          ScrollDirection.reverse &&
                      !implicitScroll.value) {
                    setState(() {
                      page += 1;
                      implicitScroll.value = true;
                    });
                    controller.animateTo(
                        (MediaQuery.of(context).size.width - 17) * page,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  } else if (controller.position.userScrollDirection ==
                          ScrollDirection.forward &&
                      !implicitScroll.value) {
                    setState(() {
                      page -= 1;
                      implicitScroll.value = true;
                    });
                    controller.animateTo(
                        (MediaQuery.of(context).size.width - 17) * page,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease);
                  }
                } else if (notificationInfo is ScrollEndNotification) {
                  setState(() {
                    implicitScroll.value = false;
                  });
                }
                return true;
              },
              child: DragAndDropGridView.horizontal(
                controller: controller,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (apps.categoryApps.length / 24).ceil(),
                    childAspectRatio: 0.98,
                    crossAxisSpacing: 2.5,
                    mainAxisSpacing: 0),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                itemBuilder: (context, index) {
                  if (index < widget.apps.categoryApps.length) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        App(
                          app: apps.categoryApps[index],
                          size: 60.0,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              apps.categoryApps[index].appName.split(' ')[0],
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: (apps.categoryApps.length / 24).ceil() * 24,
                onWillAccept: (oldIndex, newIndex) {
                  print('here');
                  return true;
                },
                onReorder: (oldIndex, newIndex) {
                  final AppInfo _temp = apps.categoryApps[newIndex];
                  apps.categoryApps[newIndex] = apps.categoryApps[oldIndex];
                  apps.categoryApps[oldIndex] = _temp;
                  box.put(
                      apps.categoryName,
                      CategoryApps(
                          categoryApps: apps.categoryApps,
                          categoryName: apps.categoryName));
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: MediaQuery.of(context).size.height * 0.04,
            alignment: Alignment.center,
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  scrollFromDot = true;
                });
              },
              onLongPressEnd: (longPressEndDetails) {
                setState(() {
                  scrollFromDot = false;
                });
              },
              onLongPressMoveUpdate: (longPressMoveUpdateDetails) {
                if (longPressMoveUpdateDetails.offsetFromOrigin.dx >
                    20 * page) {
                  setState(() {
                    page += 1;
                  });
                  controller.animateTo(
                      (MediaQuery.of(context).size.width - 17) * page,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                } else if (longPressMoveUpdateDetails.offsetFromOrigin.dx <
                    20 * page) {
                  setState(() {
                    page -= 1;
                  });
                  controller.animateTo(
                      (MediaQuery.of(context).size.width - 17) * page,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                }
              },
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: scrollFromDot ? Colors.white : Colors.transparent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        (apps.categoryApps.length / 24).ceil(),
                        (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    page = index;
                                  });
                                  controller.animateTo(
                                      (MediaQuery.of(context).size.width - 17) *
                                          page,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.ease);
                                },
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index == page
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.grey.withOpacity(0.9)),
                                ),
                              ),
                            )),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
