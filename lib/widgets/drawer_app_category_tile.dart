import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_launcher/models/app_info_model.dart';

import 'app.dart';

class DrawerAppCategoryTile extends StatelessWidget {
  DrawerAppCategoryTile(
      {Key? key, required this.categoryApps, required this.categoryName})
      : super(key: key);
  final List<AppInfo> categoryApps;
  final String categoryName;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Center(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, parentIndex) {
            if (parentIndex < 3) {
              return App(
                app: categoryApps[parentIndex],
              );
            } else {
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.4),
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Text(categoryName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24)),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Scrollbar(
                                  controller: scrollController,
                                  isAlwaysShown: false,
                                  radius: Radius.circular(5),
                                  child: GridView.builder(
                                      itemCount: categoryApps.length,
                                      controller: scrollController,
                                      padding: EdgeInsets.all(5),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            App(
                                              app: categoryApps[index],
                                              popOnLaunch: true,
                                            ),
                                            Text(
                                              categoryApps[index]
                                                  .appName
                                                  .split(' ')[0],
                                              style: TextStyle(
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, childIndex) {
                      return App(
                        app: categoryApps[childIndex + parentIndex],
                        launchOnTap: false,
                      );
                    },
                    itemCount:
                        categoryApps.length >= 7 ? 4 : categoryApps.length - 3,
                  ),
                ),
              );
            }
          },
          itemCount: categoryApps.length >= 4 ? 4 : categoryApps.length,
        ),
      ),
    );
  }
}
