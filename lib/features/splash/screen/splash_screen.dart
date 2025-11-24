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
                      horizontalInset: 10.w,
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
  final double progress; // 0.0 .. 1.0 (controller value)
  final double height;
  final double horizontalInset;
  final Color trackColor;
  final Color fillColor;

  const SimpleProgressBar({
    super.key,
    required this.progress,
    this.height = 4,
    this.horizontalInset = 10,
    this.trackColor = AllColor.white,
    this.fillColor = AllColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    // controller value clamp (0.0 .. 1.0)
    final double t = progress.clamp(0.0, 1.0).toDouble();

    // ----- left↔right multiple times -----
    // kotobar full cycle (left→right→left) hobe
    const int cycles = 3; // chaile 4 o dite paro

    final double total = t * cycles; // 0..cycles
    final int segment = total.floor(); // 0,1,2,...
    final double tCycle = total - segment; // 0..1 (current cycle position)
    final bool forward = segment.isEven; // even: left→right, odd: right→left

    // p: 0 = left, 1 = right
    final double p = forward ? tCycle : (1.0 - tCycle);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalInset),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double trackW = constraints.maxWidth;

          // puro width use korbo
          final double innerW = trackW;

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
      ),
    );
  }
}
