import 'package:flutter/material.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/drawer_app_category_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key, required this.allCategoryApps}) : super(key: key);
  final List<CategoryApps> allCategoryApps;
  @override
  Widget build(BuildContext context) {
    allCategoryApps.sort((a, b) {
      return b.categoryApps.length.compareTo(a.categoryApps.length);
    });
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.0375,
      ),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.88,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              padding: const EdgeInsets.symmetric(horizontal: 22.5),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    DrawerAppCategoryTile(
                        categoryApps: allCategoryApps[index].categoryApps,
                        categoryName: allCategoryApps[index].categoryName),
                    Text(
                      '${allCategoryApps[index].categoryName.split(' ')[0]} ${allCategoryApps[index].categoryApps.length}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                );
              },
              itemCount: allCategoryApps.length,
            ),
          ),
        ],
      ),
    );
  }
}
