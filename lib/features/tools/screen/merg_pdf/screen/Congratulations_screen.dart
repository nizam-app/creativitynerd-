import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/features/tools/widget/custom_top_back_button.dart';

class CongratulationsScreen extends StatelessWidget {
  static final routeName = '/congratulationsScreen';
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBarBackButton(title: '', icon: Icons.home_outlined),
            ConraculationTap(
              image: SvgPicture.asset('assets/images/tool/verify.svg'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConraculationTap extends StatelessWidget {
  final Widget image; // 🔹 তোমার দেওয়া image এখানে আসবে
  final String title;
  final String message;

  const ConraculationTap({
    super.key,
    required this.image,
    this.title = 'Congratulations',
    this.message = 'Your PDF has been successfully merged',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 48.h),

        // ---------- Top Image ----------
        SizedBox(
          width: 140.w,
          height: 140.w,
          child: FittedBox(fit: BoxFit.contain, child: image),
        ),

        SizedBox(height: 24.h),

        // ---------- Texts ----------
        SizedBox(
          width: 360.w,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E7780),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
