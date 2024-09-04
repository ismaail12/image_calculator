import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_calculator/features/calculator/blocs/calculate_image_cubit/calculate_image_cubit.dart';
import 'package:image_calculator/features/calculator/blocs/get_calculation_result_cubit/get_calculation_result_cubit.dart';
import 'package:image_calculator/features/calculator/blocs/save_result_cubit/save_result_cubit.dart';
import 'package:image_calculator/features/calculator/presentations/screens/home_screen.dart';

enum Flavor {
  appRedCameraRoll,
  appRedBuiltInCamera,
  appGreenFilesystem,
  appGreenCameraRoll
}

void bootstrap(Flavor flavor, String appName) => runApp(MyApp(flavor: flavor, appName: appName));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.flavor, required this.appName});

  final Flavor flavor;
  final String appName;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CalculateImageCubit(flavor),
        ),
        BlocProvider(
          create: (context) => SaveResultCubit(),
        ),
        BlocProvider(
          create: (context) => GetCalculationResultCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _getPrimaryColor(flavor)),
        ),
         builder: EasyLoading.init(),
        home: HomeScreen(flavor: flavor, appName: appName),
      ),
    );
  }

  Color _getPrimaryColor(Flavor flavor) {
    switch (flavor) {
      case Flavor.appRedCameraRoll:
      case Flavor.appRedBuiltInCamera:
        return Colors.red;
      case Flavor.appGreenFilesystem:
      case Flavor.appGreenCameraRoll:
        return Colors.green;
      default:
        return Colors.blue; // Default color if no flavor is selected.
    }
  }
}