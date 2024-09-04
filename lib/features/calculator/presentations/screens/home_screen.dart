
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_calculator/bootstrap.dart';
import 'package:image_calculator/features/calculator/blocs/calculate_image_cubit/calculate_image_cubit.dart';
import 'package:image_calculator/features/calculator/presentations/screens/database_storage_screen.dart';
import 'package:image_calculator/features/calculator/presentations/screens/file_storage_screen.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:image_calculator/features/calculator/presentations/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  final Flavor flavor;
  final String appName;

  const HomeScreen({super.key, required this.flavor, required this.appName});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appName,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              height: 60,
              color: Theme.of(context)
                  .scaffoldBackgroundColor, 
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(0.2),
                ),
                indicatorPadding: const EdgeInsets.all(8),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'File Storage (Encrypted)',),
                  Tab(text: 'Database Storage'),
                ],
              ),
            ),
          ),
        ),
        body: BlocListener<CalculateImageCubit, CalculateImageState>(
          listener: (context, state) {
            if (state is CalculateImageLoading) {
              EasyLoading.show(status: 'Processing');
            }

            if (state is CalculateImageSuccess) {
              EasyLoading.dismiss();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SuccessScreen(result: state.result),
                ),
              );
            } else if (state is CalculateImageFailure) {
              EasyLoading.dismiss();
            }
          },
          child: const TabBarView(
            children: [
              FileStorageScreen(), 
              DatabaseStorageScreen(), 
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: 'Add Input',
            onPressed: () {
              context.read<CalculateImageCubit>().calculateImage();
            },
          ),
        ),
      ),
    );
  }
}




