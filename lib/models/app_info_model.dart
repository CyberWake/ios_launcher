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
        appName: json['appName'],
        appPackage: json['package'],
        appIcon: json['icon'],
        appCategory: json['category']);
  }

  @HiveField(0)
  String appName;
  @HiveField(1)
  String appPackage;
  @HiveField(2)
  String appIcon;
  @HiveField(3)
  String appCategory;

  static listOfMapToListOfAppInfo(List<dynamic> appList) {
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
