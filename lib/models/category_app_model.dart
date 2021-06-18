import 'package:hive/hive.dart';
import 'package:ios_launcher/models/app_info_model.dart';

part 'category_app_model.g.dart';

@HiveType(typeId: 2)
class CategoryApps {
  CategoryApps({required this.categoryApps, required this.categoryName});
  @HiveField(0)
  List<AppInfo> categoryApps;
  @HiveField(1)
  String categoryName;
}
