import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ios_launcher/models/app_info_model.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:path_provider/path_provider.dart' as path;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory dir = await path.getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapter(AppInfoAdapter())
    ..registerAdapter(CategoryAppsAdapter());
  await Hive.openBox<CategoryApps>('categoryApps');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform =
      const MethodChannel('com.cyberwake.ioslauncher/platformData');
  int _counter = 0;
  late List result;

  Future<void> getApps() async {
    try {
      result = (await platform.invokeListMethod('getApps'))!;
      if (result.isNotEmpty) {
        result.sort((a, b) {
          return a['appName']
              .toLowerCase()
              .compareTo(b['appName'].toLowerCase());
        });
        final String playStoreUrl =
            "https://play.google.com/store/apps/details?id=";
        for (int i = 0; i < result.length; i++) {
          print(result[i]['appName']);
          var response =
              await http.get(Uri.parse('$playStoreUrl${result[i]['package']}'));
          if (response.statusCode == 200) {
            var document = parse(response.body);
            result[i]['category'] =
                document.querySelector('a[itemprop]="genre"')!.text;
          }
        }
        List categoryNames = [];
        print(result.length);
        result.forEach((element) {
          if (!categoryNames.contains(element['category'])) {
            categoryNames.add(element['category']);
          }
        });
        List<AppInfo> applications = AppInfo.listOfMapToListOfAppInfo(result);
        final List<CategoryApps> categoryApps = [];
        for (int i = 0; i < categoryNames.length; i++) {
          List<AppInfo> category = [];
          applications.forEach((element) {
            if (element.appCategory == categoryNames[i]) {
              category.add(element);
            }
          });
          CategoryApps apps = CategoryApps(
              categoryApps: category, categoryName: categoryNames[i]);
          categoryApps.add(apps);
        }
        categoryApps.sort((a, b) {
          return a.categoryApps.length.compareTo(b.categoryApps.length);
        });
        categoryApps.forEach((element) {
          print(
              '\ncategory: ${element.categoryName}, apps: ${element.categoryApps.length}\n ');
          element.categoryApps.forEach((ele) {
            if (element.categoryName != 'Undefined') {
              print(ele.appName);
            } else {
              print(ele.appPackage);
            }
          });
        });
        final box = Hive.box<CategoryApps>('categoryApps');
        if (box.length == 0) {
          categoryApps.forEach((element) {
            box.add(element);
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  retrieve() {
    final retrievedCategoryApps = [];
    final box = Hive.box<CategoryApps>('categoryApps');
    for (int i = 0; i < box.length; i++) {
      retrievedCategoryApps.add(box.getAt(i));
    }
    retrievedCategoryApps.forEach((element) {
      print(
          '\ncategory: ${element.categoryName}, apps: ${element.categoryApps.length}\n ');
      element.categoryApps.forEach((ele) {
        if (element.categoryName != 'Undefined') {
          print(ele.appName);
        } else {
          print(ele.appPackage);
        }
      });
    });
  }

  @override
  void initState() {
    final box = Hive.box<CategoryApps>('categoryApps');
    if (box.isEmpty) {
      print('here');
      getApps();
    } else {
      print('here1');
      retrieve();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: getApps,
        onPressed: retrieve,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
