import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ios_launcher/app_drawer.dart';
import 'package:ios_launcher/home.dart';
import 'package:ios_launcher/models/app_info_model.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:path_provider/path_provider.dart' as path;

const platform = MethodChannel('com.cyberwake.ioslauncher/platformData');
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List result = [];
  late List<CategoryApps> retrievedCategoryApps = [];
  final List<CategoryApps> categoryAppsList = [];
  int pageIndex = 0;
  PageController controller = PageController();

  Future<void> getApps() async {
    try {
      result = (await platform.invokeListMethod('getApps')) ?? [];
      if (result.isNotEmpty) {
        result.sort((a, b) {
          return a['appName']
              .toString()
              .toLowerCase()
              .compareTo(b['appName'].toString().toLowerCase());
        });
        const String playStoreUrl =
            "https://play.google.com/store/apps/details?id=";
        for (int i = 0; i < result.length; i++) {
          if (result[i]['category'] == "Undefined") {
            final response = await http
                .get(Uri.parse('$playStoreUrl${result[i]['package']}'));
            if (response.statusCode == 200) {
              final document = parse(response.body);
              result[i]['category'] =
                  document.querySelector('a[itemprop]="genre"')!.text;
            }
          }
        }
        final List<String> categoryNames = [];
        result.forEach((element) {
          if (!categoryNames.contains(element['category'])) {
            categoryNames.add(element['category'] as String);
          }
        });
        final List<AppInfo> applications =
            AppInfo.listOfMapToListOfAppInfo(result);
        categoryAppsList.add(CategoryApps(
            categoryApps: applications, categoryName: 'SortedAllApp'));
        for (int i = 0; i < categoryNames.length; i++) {
          final List<AppInfo> category = [];
          applications.forEach((element) {
            if (element.appCategory == categoryNames[i]) {
              category.add(element);
            }
          });
          final CategoryApps apps = CategoryApps(
              categoryApps: category, categoryName: categoryNames[i]);
          categoryAppsList.add(apps);
        }
        categoryAppsList.sort((a, b) {
          return a.categoryName.compareTo(b.categoryName);
        });
        if (result.isNotEmpty) {
          final box = Hive.box<CategoryApps>('categoryApps');
          if (box.length != 0) {
            box.clear();
          }
          categoryAppsList.forEach((element) {
            box.put(element.categoryName, element);
          });
          setState(() {
            retrievedCategoryApps = categoryAppsList;
            print('saved');
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  retrieve() {
    final box = Hive.box<CategoryApps>('categoryApps');
    retrievedCategoryApps = [];
    print(box.length);
    for (int i = 0; i < box.length; i++) {
      retrievedCategoryApps.add(box.getAt(i)!);
    }
    retrievedCategoryApps.forEach((element) {
      print(
          'category: ${element.categoryName}, apps: ${element.categoryApps.length}\n ');
    });
    setState(() {});
  }

  clearHive() {
    print(retrievedCategoryApps
            .where((element) => element.categoryName == "SortedAllApp")
            .toList()
            .first
            .categoryApps
            .length %
        20);
    // retrievedCategoryApps.forEach((element) {
    //   print(element.categoryName);
    // });
    // final box = Hive.box<CategoryApps>('categoryApps');
    // box.clear();
  }

  @override
  void initState() {
    final box = Hive.box<CategoryApps>('categoryApps');
    if (box.isEmpty) {
      getApps();
    } else {
      print('here1');
      retrieve();
    }
    super.initState();
  }

  void openDrawer() {
    controller.animateToPage(1,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.jpg'),
                      fit: BoxFit.fitWidth)),
            ),
            // if (pageIndex != 0)
            //
            PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
              children: [
                Home(
                  categoryApps: retrievedCategoryApps,
                  openDrawer: openDrawer,
                ),
                Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: Colors.black.withOpacity(0.01),
                      ),
                    ),
                    AppDrawer(
                      allCategoryApps: retrievedCategoryApps
                          .where((element) =>
                              element.categoryName != "SortedAllApp" &&
                              element.categoryName != "Tray Apps")
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: getApps,
          // onPressed: retrieve,
          // onPressed: clearHive,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
