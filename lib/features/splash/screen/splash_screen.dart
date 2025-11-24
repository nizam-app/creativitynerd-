
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';

import '../../onbording/screens/onboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 🔹 4 sec e 0 → 1
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go(OnboardingScreen.routeName);
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  height: 208.h,
                  width: 208.w,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Image.asset(
                    "assets/images/splash.gif",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "PDF Scanner",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: AllColor.black,
                    fontFamily: "sf_Pro",
                  ),
                ),
                Text(
                  "Scan anything, anytime, anywhere",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AllColor.black,
                    fontFamily: "sf_Pro",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),

                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return SimpleProgressBar(
                      progress: _animation.value, // 0.0 .. 1.0
                      height: 6.h,
                      horizontalInset: 50.w,
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double horizontalInset;
  final Color trackColor;
  final Color fillColor;

  const SimpleProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
    this.horizontalInset = 30,
    this.trackColor = AllColor.white,
    this.fillColor = AllColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    // controller value clamp (0.0 .. 1.0)
    final double t = progress.clamp(0.0, 1.0).toDouble();

    // মোট ১টা টাইমলাইনকে দুই ভাগে ভাগ করলাম
    const double forwardPart = 0.6; // 60% সময় forward (left → right)
    const double backPart = 1.0 - forwardPart; // 40% সময় back (right → center)

    double p; // 0 = left, 1 = right, 0.5 = center

    if (t <= forwardPart) {
      // প্রথম ৬০% : একদম বাম থেকে একদম ডানে যাবে
      final double phase = t / forwardPart; // 0..1
      p = phase; // 0..1
    } else {
      // পরের ৪০% : ডান থেকে center এ ফিরে আসবে
      final double phase = (t - forwardPart) / backPart; // 0..1
      p = 1.0 - 0.5 * phase; // 1.0 → 0.5
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double trackW = constraints.maxWidth;

        final double innerW = (trackW - horizontalInset * 2).clamp(
          0.0,
          double.infinity,
        );

        // segment total width er 60%
        const double segmentFraction = 0.60;
        final double segmentW = innerW * segmentFraction;

        // সর্বোচ্চ offset (একদম ডান প্রান্ত)
        final double maxOffset = innerW - segmentW;
        final double offset = maxOffset * p;

        return Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(height),
          ),
          child: Stack(
            children: [
              Positioned(
                left: offset,
                top: 0,
                bottom: 0,
                child: Container(
                  width: segmentW,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
