import 'package:flutter/material.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/home_apps_page.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class HomeApps extends StatefulWidget {
  const HomeApps({Key? key, required this.apps}) : super(key: key);
  final CategoryApps apps;

  @override
  _HomeAppsState createState() => _HomeAppsState();
}

class _HomeAppsState extends State<HomeApps> {
  late CategoryApps apps;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    apps = widget.apps;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
        Expanded(
          child: PageView.builder(
              itemCount: (apps.categoryApps.length / 20).ceil(),
              itemBuilder: (BuildContext context, int pageIndex) {
                if ((pageIndex + 1) * 20 < apps.categoryApps.length) {
                  return HomeAppsPage(
                      pageApps: apps.categoryApps
                          .sublist(pageIndex * 20, (pageIndex + 1) * 20));
                } else {
                  return HomeAppsPage(
                      pageApps: apps.categoryApps.sublist(pageIndex * 20));
                }
              },
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
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
}
