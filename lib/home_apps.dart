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

  @override
  void initState() {
    apps = widget.apps;
    controller.addListener(() {
      if (controller.page! > 6.0) {
        controller.animateToPage((apps.categoryApps.length / 20).ceil() - 1,
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
        Expanded(
          child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              itemCount: (apps.categoryApps.length / 20).ceil() + 1,
              itemBuilder: (BuildContext context, int pageIndex) {
                if ((pageIndex + 1) * 20 < apps.categoryApps.length) {
                  return HomeAppsPage(
                      categoryName: apps.categoryName,
                      pageApps: apps.categoryApps
                          .sublist(pageIndex * 20, (pageIndex + 1) * 20));
                } else if (pageIndex < (apps.categoryApps.length / 20).ceil()) {
                  return HomeAppsPage(
                      categoryName: apps.categoryName,
                      pageApps: apps.categoryApps.sublist(pageIndex * 20));
                } else {
                  return Container();
                }
              },
              onPageChanged: (int index) {
                print(index);
                if (index == (apps.categoryApps.length / 20).ceil()) {
                  controller.animateToPage(
                      (apps.categoryApps.length / 20).ceil() - 1,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.ease);
                  widget.openDrawer();
                } else {
                  _currentPageNotifier.value = index;
                }
              }),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.025,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.1425),
          child: Center(
            child: CirclePageIndicator(
              dotColor: Colors.white.withOpacity(0.4),
              selectedDotColor: Colors.white.withOpacity(0.7),
              itemCount: (apps.categoryApps.length / 20).ceil(),
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
