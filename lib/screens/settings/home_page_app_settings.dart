import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ios_launcher/models/category_app_model.dart';

class HomePageAppSettings extends StatefulWidget {
  const HomePageAppSettings({Key? key}) : super(key: key);

  @override
  _HomePageAppSettingsState createState() => _HomePageAppSettingsState();
}

class _HomePageAppSettingsState extends State<HomePageAppSettings> {
  late final CategoryApps homePageApps;

  getHomePageApp() {
    final box = Hive.box<CategoryApps>('categoryApps');
    homePageApps = box.get('SortedAllApp')!;
  }

  @override
  void initState() {
    getHomePageApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launcher Settings'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: homePageApps.categoryApps.length,
          itemBuilder: (BuildContext context, int index) {
            if (homePageApps.categoryApps[index].appName.isNotEmpty) {
              return ListTile(
                leading: Image.memory(homePageApps.categoryApps[index].appIcon),
                title: Text(homePageApps.categoryApps[index].appName),
                trailing: Checkbox(
                  onChanged: (bool? value) {},
                  value: true,
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
