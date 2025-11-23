import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';
import 'package:pdf_scanner/routes/app_routes.dart';
import 'core/constants/color_control/all_color.dart';
import 'core/constants/color_control/theme_color_controller.dart';

import 'core/utils/translation_text.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        brightness:  Brightness.light,   
        colorScheme: ColorScheme.light(
          primary: AllColor.black,
          onPrimary:  AllColor.white,
          secondary: ThemeColorController.green,
          onSecondary: AllColor.white,
          surface: ThemeColorController.grey,
          onSurface: ThemeColorController.white, 
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xffA49ACF).withOpacity(0.05),
          // Background same like screenshot
          contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),

          hintStyle: TextStyle(
            color: AllColor.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),

          suffixIconColor: Colors.grey,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.r),
          //   borderSide: BorderSide(color: AllColor.borderColor, width: 1.2),
          // ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AllColor.black, width: 1),
          ),
          //
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AllColor.black, width: 1.2),
          ),

        ),
        // apply globally
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
            fontFamily: "bodyFont",
            fontWeight: FontWeight.w400,
            // letterSpacing: 1
          ),
          titleSmall: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w300,
            color: AllColor.black,
            fontFamily: "bodyFont",
          ),
          headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          headlineLarge: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
            color: AllColor.black,
            fontFamily: "bodyFont",
          ),
          bodySmall: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            fontFamily: "bodyFont",
            color: AllColor.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: "bodyFont",
            color: AllColor.black,
          ),
        ),
        scaffoldBackgroundColor: ToolFlowColor.backGroundColor,
      ),
      routerConfig: AppRouter.appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}