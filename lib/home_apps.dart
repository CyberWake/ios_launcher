import 'package:flutter/material.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/home_apps_page.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class HomeApps extends StatefulWidget {
  const HomeApps({Key? key, required this.apps, required this.openDrawer})
      : super(key: key);
  final CategoryApps apps;
  final Function openDrawer;

  @override
  _HomeAppsState createState() => _HomeAppsState();
}

class _HomeAppsState extends State<HomeApps>
    with AutomaticKeepAliveClientMixin<HomeApps> {
  late CategoryApps apps;
  final _currentPageNotifier = ValueNotifier<int>(0);
  final PageController controller = PageController();
  bool hasReachedEnd = false;
  bool hasReachedFirst = true;
  bool isDragging = false;
  int navigating = 0;

  @override
  void initState() {
    apps = widget.apps;
    controller.addListener(() {
      if (controller.page! > 6.0) {
        controller.animateToPage((apps.categoryApps.length / 24).ceil() - 1,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
        widget.openDrawer();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
            child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                itemCount: (apps.categoryApps.length / 24).ceil() + 1,
                itemBuilder: (BuildContext context, int pageIndex) {
                  if ((pageIndex + 1) * 24 < apps.categoryApps.length) {
                    return HomeAppsPage(
                        categoryName: apps.categoryName,
                        pageApps: apps.categoryApps
                            .sublist(pageIndex * 24, (pageIndex + 1) * 24));
                  } else if (pageIndex <
                      (apps.categoryApps.length / 24).ceil()) {
                    return HomeAppsPage(
                        categoryName: apps.categoryName,
                        pageApps: apps.categoryApps.sublist(pageIndex * 24));
                  } else {
                    return Container();
                  }
                },
                onPageChanged: (int index) {
                  print(index);
                  if (index == (apps.categoryApps.length / 24).ceil()) {
                    controller.animateToPage(
                        (apps.categoryApps.length / 24).ceil() - 1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease);
                    widget.openDrawer();
                  } else {
                    _currentPageNotifier.value = index;
                  }
                }),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.186,
          alignment: Alignment.topCenter,
          child: GestureDetector(
            onLongPress: () {
              setState(() {
                isDragging = true;
                navigating = 0;
              });
            },
            onLongPressEnd: (longPressEndDetails) {
              setState(() {
                isDragging = false;
                navigating = 0;
              });
            },
            onLongPressMoveUpdate: (longPressMoveUpdateDetails) {
              // print(longPressMoveUpdateDetails.globalPosition);
              // print(longPressMoveUpdateDetails.localOffsetFromOrigin);
              // print(longPressMoveUpdateDetails.localPosition);
              print(longPressMoveUpdateDetails.offsetFromOrigin);
              if (longPressMoveUpdateDetails.offsetFromOrigin.dx >
                  20 * navigating) {
                controller.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
                setState(() {
                  navigating += 1;
                });
              } else if (longPressMoveUpdateDetails.offsetFromOrigin.dx <
                  -20 * navigating) {
                controller.animateToPage(_currentPageNotifier.value - 1,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
                setState(() {
                  navigating += 1;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isDragging ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: CirclePageIndicator(
                dotColor: isDragging
                    ? Colors.black.withOpacity(0.4)
                    : Colors.white.withOpacity(0.4),
                selectedDotColor: isDragging
                    ? Colors.black.withOpacity(0.7)
                    : Colors.white.withOpacity(0.7),
                itemCount: (apps.categoryApps.length / 24).ceil(),
                currentPageNotifier: _currentPageNotifier,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
