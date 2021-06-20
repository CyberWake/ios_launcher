import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'app_info_model.g.dart';

@HiveType(typeId: 1)
class AppInfo {
  AppInfo(
      {required this.appName,
      required this.appPackage,
      required this.appIcon,
      required this.appCategory});

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
        appName: json['appName'] as String,
        appPackage: json['package'] as String,
        appIcon: json['icon'] as Uint8List,
        appCategory: json['category'] as String);
  }

  @HiveField(0)
  String appName;
  @HiveField(1)
  String appPackage;
  @HiveField(2)
  Uint8List appIcon;
  @HiveField(3)
  String appCategory;

  static List<AppInfo> listOfMapToListOfAppInfo(List<dynamic> appList) {
    final List<AppInfo> _applications = [];
    appList.forEach((element) {
      _applications.add(AppInfo.fromJson({
        'appName': element['appName'],
        'package': element['package'],
        'icon': element['icon'],
        'category': element['category']
      }));
    });
    return _applications;
  }
}
