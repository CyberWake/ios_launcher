import 'package:flutter/material.dart';
import 'package:ios_launcher/main.dart';
import 'package:ios_launcher/models/app_info_model.dart';

class App extends StatelessWidget {
  const App(
      {Key? key,
      required this.app,
      this.popOnLaunch = false,
      this.size = 55,
      this.launchOnTap = true,
      this.onTapApp = false})
      : super(key: key);
  final AppInfo app;
  final bool popOnLaunch;
  final double size;
  final bool launchOnTap;
  final bool onTapApp;

  @override
  Widget build(BuildContext context) {
    return launchOnTap
        ? GestureDetector(
            onTap: () async {
              final Map<String, dynamic> args = <String, dynamic>{};
              args.putIfAbsent('uri', () => app.appPackage);
              final bool result =
                  await platform.invokeMethod("launchApp", args) as bool;
              if (result && popOnLaunch) {
                Navigator.pop(context);
              }
            },
            child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: onTapApp
                        ? BorderRadius.circular(7.5)
                        : BorderRadius.circular(size / 4),
                    image: DecorationImage(
                        image: MemoryImage(app.appIcon), fit: BoxFit.fill))),
          )
        : Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: onTapApp
                    ? BorderRadius.circular(7.5)
                    : BorderRadius.circular(size / 4),
                image: DecorationImage(
                    image: MemoryImage(app.appIcon), fit: BoxFit.fill)));
  }
}
