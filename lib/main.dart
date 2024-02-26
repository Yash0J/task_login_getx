import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/constants/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'view/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryColor,
            background: AppColors.darkBlue,
            secondary: AppColors.purple,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        getPages: [
          GetPage(name: '/login', page: () => LoginPage()),
        ],
      );
    });
  }
}
