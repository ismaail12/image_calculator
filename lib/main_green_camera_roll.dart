import 'package:flutter/material.dart';
import 'package:image_calculator/bootstrap.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();
  final appName = packageInfo.appName;

  bootstrap(Flavor.appGreenCameraRoll, appName);
}
