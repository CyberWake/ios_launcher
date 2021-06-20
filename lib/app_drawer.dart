import 'package:flutter/material.dart';
import 'package:ios_launcher/models/category_app_model.dart';
import 'package:ios_launcher/widgets/drawer_app_category_tile.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key, required this.allCategoryApps}) : super(key: key);
  final List<CategoryApps> allCategoryApps;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    widget.allCategoryApps.sort((a, b) {
      return b.categoryApps.length.compareTo(a.categoryApps.length);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        categoryApps:
                            widget.allCategoryApps[index].categoryApps,
                        categoryName:
                            widget.allCategoryApps[index].categoryName),
                    Text(
                      widget.allCategoryApps[index].categoryName.split(' ')[0],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                );
              },
              itemCount: widget.allCategoryApps.length,
            ),
          ),
        ],
      ),
    );
  }
}
