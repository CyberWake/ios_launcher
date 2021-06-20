import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ios_launcher/models/app_info_model.dart';
import 'package:ios_launcher/widgets/app.dart';

class DrawerAppCategoryTile extends StatelessWidget {
  DrawerAppCategoryTile(
      {Key? key, required this.categoryApps, required this.categoryName})
      : super(key: key);
  final List<AppInfo> categoryApps;
  final String categoryName;
  final ScrollController scrollController = ScrollController();

  double getPadding(BuildContext context) {
    if (categoryApps.length <= 4) {
      return MediaQuery.of(context).size.height * 0.35;
    } else if (categoryApps.length <= 8) {
      return MediaQuery.of(context).size.height * 0.26;
    } else if (categoryApps.length <= 12) {
      return MediaQuery.of(context).size.height * 0.255;
    } else if (categoryApps.length <= 16) {
      return MediaQuery.of(context).size.height * 0.19;
    } else if (categoryName.length > 18) {
      return MediaQuery.of(context).size.height * 0.1;
    } else {
      return MediaQuery.of(context).size.height * 0.075;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(7.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Center(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5),
          itemBuilder: (context, parentIndex) {
            if (parentIndex < 3) {
              return Hero(
                tag: categoryApps[parentIndex],
                child: App(
                  app: categoryApps[parentIndex],
                ),
              );
            } else {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          fullscreenDialog: false,
                          opaque: false,
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return Material(
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  // AlertDialog()
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: getPadding(context)),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(categoryName,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 36)),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Expanded(
                                            child: CupertinoScrollbar(
                                              controller: scrollController,
                                              isAlwaysShown: false,
                                              radius: const Radius.circular(5),
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      categoryApps.length,
                                                  controller: scrollController,
                                                  padding: EdgeInsets.zero,
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 4,
                                                    childAspectRatio: 0.88,
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Column(
                                                      children: [
                                                        Hero(
                                                          tag: categoryApps[
                                                              index],
                                                          child: App(
                                                            app: categoryApps[
                                                                index],
                                                            popOnLaunch: true,
                                                          ),
                                                        ),
                                                        Text(
                                                          categoryApps[index]
                                                              .appName
                                                              .split(' ')[0],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }));
                  // showDialog(
                  //     context: context,
                  //     barrierColor: Colors.black.withOpacity(0.4),
                  //     builder: (BuildContext context) {
                  //       return Stack(
                  //         children: [
                  //           // AlertDialog()
                  //           BackdropFilter(
                  //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  //             child: Container(),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () => Navigator.pop(context),
                  //             child: Padding(
                  //               padding: EdgeInsets.symmetric(
                  //                   horizontal: 20,
                  //                   vertical: categoryApps.length <= 4
                  //                       ? MediaQuery.of(context).size.height *
                  //                       0.35
                  //                       : categoryApps.length <= 8
                  //                       ? MediaQuery.of(context)
                  //                       .size
                  //                       .height *
                  //                       0.26
                  //                       : categoryApps.length <= 12
                  //                       ? MediaQuery.of(context)
                  //                       .size
                  //                       .height *
                  //                       0.155
                  //                       : categoryApps.length <= 16
                  //                       ? MediaQuery.of(context)
                  //                       .size
                  //                       .height *
                  //                       0.1
                  //                       : MediaQuery.of(context)
                  //                       .size
                  //                       .height *
                  //                       0.08),
                  //               child: Center(
                  //                 child: Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   crossAxisAlignment:
                  //                   CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text(categoryName,
                  //                         style: const TextStyle(
                  //                             color: Colors.white,
                  //                             fontWeight: FontWeight.w700,
                  //                             fontSize: 36)),
                  //                     const SizedBox(
                  //                       height: 15,
                  //                     ),
                  //                     Expanded(
                  //                       child: CupertinoScrollbar(
                  //                         controller: scrollController,
                  //                         isAlwaysShown: false,
                  //                         radius: const Radius.circular(5),
                  //                         child: GridView.builder(
                  //                             shrinkWrap: true,
                  //                             itemCount: categoryApps.length,
                  //                             controller: scrollController,
                  //                             padding: const EdgeInsets.all(5),
                  //                             gridDelegate:
                  //                             const SliverGridDelegateWithFixedCrossAxisCount(
                  //                               crossAxisCount: 4,
                  //                               childAspectRatio: 0.7,
                  //                             ),
                  //                             itemBuilder:
                  //                                 (BuildContext context,
                  //                                 int index) {
                  //                               return Column(
                  //                                 children: [
                  //                                   Hero(
                  //                                     tag: categoryApps[index],
                  //                                     child: App(
                  //                                       app:
                  //                                       categoryApps[index],
                  //                                       popOnLaunch: true,
                  //                                     ),
                  //                                   ),
                  //                                   Text(
                  //                                     categoryApps[index]
                  //                                         .appName
                  //                                         .split(' ')[0],
                  //                                     style: const TextStyle(
                  //                                         color: Colors.white),
                  //                                     overflow:
                  //                                     TextOverflow.ellipsis,
                  //                                   ),
                  //                                 ],
                  //                               );
                  //                             }),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     });
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, childIndex) {
                      return Hero(
                        tag: categoryApps[childIndex + parentIndex],
                        child: App(
                          app: categoryApps[childIndex + parentIndex],
                          launchOnTap: false,
                        ),
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
