import 'package:flutter/material.dart';
import 'package:ios_launcher/models/app_info_model.dart';

import '../main.dart';

class App extends StatelessWidget {
  const App(
      {Key? key,
      required this.app,
      this.popOnLaunch = false,
      this.size = 55,
      this.launchOnTap = true})
      : super(key: key);
  final AppInfo app;
  final bool popOnLaunch;
  final double size;
  final bool launchOnTap;

  @override
  Widget build(BuildContext context) {
    return launchOnTap
        ? GestureDetector(
            onTap: () async {
              Map<String, dynamic> args = <String, dynamic>{};
              args.putIfAbsent('uri', () => app.appPackage);
              final bool result =
                  await platform.invokeMethod("launchApp", args);
              if (result && popOnLaunch) {
                Navigator.pop(context);
              }
            },
            child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: MemoryImage(app.appIcon)))),
          )
        : Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(image: MemoryImage(app.appIcon))));
  }
}
