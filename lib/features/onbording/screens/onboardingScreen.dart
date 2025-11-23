import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/globalCustomButton.dart';
import 'package:pdf_scanner/features/navbar/screen/navbar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  static const _autoDuration = Duration(seconds: 3);
  static const _tick = Duration(milliseconds: 50);

  final _slides = const <_Slide>[
    _Slide(
      svg: 'assets/images/quick.png',
      title: 'Quick scanner in\nyour pocket',
      subtitle:
      'Scan, sign and share document with text recognition, saving in any format',
    ),
    _Slide(
      svg: 'assets/images/quick1.png',
      title: 'Conversion tool',
      subtitle:
      'Flip files easily between JPEG, TXT, and high-resolution PDF formats',
    ),
    _Slide(
      svg: 'assets/images/quick2.png',
      title: 'eSign and edit\ndocuments',
      subtitle:
      'Crop, rotate, change to black and white,\nand many other features',
    ),
    _Slide(
      svg: 'assets/images/scan.png',
      title: 'Recognises text from\ndocuments',
      subtitle: 'Extract text from printed documents and \n images with precision',
    ),
  ];

  int _index = 0;
  double _progress = 0;
  Timer? _timer;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _startAuto();
  }

  void _startAuto() {
    _timer?.cancel();
    _timer = Timer.periodic(_tick, (t) {
      if (!mounted || _dragging) return;

      setState(() {
        _progress += _tick.inMilliseconds / _autoDuration.inMilliseconds;

        if (_progress >= 1) {
          _progress = 0;

          final isLast = _index == _slides.length - 1;

          if (isLast) {
            t.cancel();
            // go to navbar after frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) context.go(BottomNavBar.routeName);
            });
            return;
          }

          final next = _index + 1; // ✅ NO modulo, so no loop
          _controller.animateToPage(
            next,
            duration: const Duration(milliseconds: 350),
            curve: Curves.ease,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    final isLast = _index == _slides.length - 1;

    if (!isLast) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
      );
    } else {
      context.go(BottomNavBar.routeName);
    }
  }

  void _onSkip() {
    context.go(BottomNavBar.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image (png)
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),

                  _ProgressSegments(
                    count: _slides.length,
                    activeIndex: _index,
                    activeProgress: _progress,
                  ),

                  SizedBox(height: 16.h),

                  // Skip button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _onSkip,
                      child: Container(
                        height: 40.h,
                        width: 72.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AllColor.gery,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "sf_Pro",
                              color: AllColor.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Pager
                  Expanded(
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (n) {
                        if (n.direction == ScrollDirection.idle) {
                          _dragging = false;
                          return false;
                        }
                        _dragging = true;
                        return false;
                      },
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _slides.length,
                        onPageChanged: (i) {
                          setState(() {
                            _index = i;
                            _progress = 0;
                          });
                        },
                        itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  GlobalCustomButton(
                    title: "Continue",
                    onPressed: _onContinue,
                  ),
                  SizedBox(height: 14.h),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'By continuing, you agree to our',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AllColor.black.withOpacity(0.45),
                          fontWeight: FontWeight.w500,
                          fontFamily: "sf_Pro",
                          height: 1.2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LinkText(
                            'Terms of service',
                            onTap: () {},
                          ),
                          Text(
                            ' and ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AllColor.black.withOpacity(0.45),
                              fontWeight: FontWeight.w500,
                              fontFamily: "sf_Pro",
                              height: 1.2,
                            ),
                          ),
                          _LinkText(
                            'Privacy Policy',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Slide model
class _Slide {
  final String svg;
  final String title;
  final String subtitle;
  const _Slide({
    required this.svg,
    required this.title,
    required this.subtitle,
  });
}

// Slide view widget
class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});
  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              slide.svg,
              width: 278.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: AllColor.black,
            fontFamily: "sf_Pro",
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          slide.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: AllColor.black.withOpacity(0.7),
            fontFamily: "sf_Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Link text for terms and privacy
class _LinkText extends StatelessWidget {
  const _LinkText(this.text, {required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        child: Text(
          text,
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: AllColor.black.withOpacity(0.45),
            decorationThickness: 1.5,
            fontSize: 14.sp,
            color: AllColor.black.withOpacity(0.45),
            fontFamily: "sf_Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Thin segmented progress bar (top)
class _ProgressSegments extends StatelessWidget {
  const _ProgressSegments({
    required this.count,
    required this.activeIndex,
    required this.activeProgress,
  });

  final int count;
  final int activeIndex;
  final double activeProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.h,
      child: Row(
        children: List.generate(count, (i) {
          final filled = (i < activeIndex)
              ? 1.0
              : (i == activeIndex ? activeProgress : 0.0);
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: AllColor.gery,
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: filled.clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AllColor.black,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
// import 'package:pdf_scanner/core/widget/globalCustomButton.dart';
// import 'package:pdf_scanner/features/navbar/screen/navbar.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//   static const routeName = '/onboarding';
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final _controller = PageController();
//
//   static const _autoDuration = Duration(seconds: 3);
//   static const _tick = Duration(milliseconds: 50);
//
//   final _slides = const <_Slide>[
//     _Slide(
//       svg: 'assets/images/quick.png',
//       title: 'Quick scanner in\nyour pocket',
//       subtitle:
//       'Scan, sign and share document with text recognition, saving in any format',
//     ),
//     _Slide(
//       svg: 'assets/images/quick1.png',
//       title: 'Conversion tool',
//       subtitle:
//       'Flip files easily between JPEG, TXT, and high-resolution PDF formats',
//     ),
//     _Slide(
//       svg: 'assets/images/quick2.png',
//       title: 'eSign and edit\ndocuments',
//       subtitle:
//       'Crop, rotate, change to black and white,\nand many other features',
//     ),
//     _Slide(
//       svg: 'assets/images/scan.png',
//       title: 'Recognises text from\ndocuments',
//       subtitle:
//       'Extract text from printed documents and \n images with precision',
//     ),
//   ];
//
//   int _index = 0;
//   double _progress = 0;
//   Timer? _timer;
//   bool _dragging = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _startAuto();
//   }
//
//   void _startAuto() {
//     _timer?.cancel();
//     _timer = Timer.periodic(_tick, (t) {
//       if (!mounted || _dragging) return;
//       setState(() {
//         _progress += _tick.inMilliseconds / _autoDuration.inMilliseconds;
//         if (_progress >= 1) {
//           _progress = 0;
//           final next = (_index + 1) % _slides.length;
//           _controller.animateToPage(
//             next,
//             duration: const Duration(milliseconds: 350),
//             curve: Curves.ease,
//           );
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onContinue() {
//     if (_index < _slides.length - 1) {
//       // Go to the next slide
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 350),
//         curve: Curves.ease,
//       );
//     } else {
//       // If last slide, navigate to the home page (or another screen)
//       context.go(BottomNavBar.routeName);  // Navigate to home screen or BottomNavBar
//     }
//   }
//
//   void _onSkip() {
//     // Skip directly to the home screen or BottomNavBar
//     context.go(BottomNavBar.routeName);  // Navigate to home screen or BottomNavBar
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background image (png)
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/back.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // Content
//           SafeArea(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 children: [
//                   SizedBox(height: 8.h),
//
//                   // Top progress bar
//                   _ProgressSegments(
//                     count: _slides.length,
//                     activeIndex: _index,
//                     activeProgress: _progress,
//                   ),
//
//                   SizedBox(height: 16.h),
//
//                   // Skip button
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: GestureDetector(
//                       onTap: _onSkip,
//                       child: Container(
//                         height: 40.h,
//                         width: 72.w,
//                         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                         decoration: BoxDecoration(
//                           color: AllColor.gery,
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Skip',
//                             style: TextStyle(
//                               fontSize: 17.sp,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: "sf_Pro",
//                               color: AllColor.black,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 10.h),
//
//                   // Pager
//                   Expanded(
//                     child: NotificationListener<UserScrollNotification>(
//                       onNotification: (n) {
//                         if (n.direction == ScrollDirection.idle) {
//                           _dragging = false;
//                           return false;
//                         }
//                         _dragging = true;
//                         return false;
//                       },
//                       child: PageView.builder(
//                         controller: _controller,
//                         itemCount: _slides.length,
//                         onPageChanged: (i) {
//                           setState(() {
//                             _index = i;
//                             _progress = 0;
//                           });
//                         },
//                         itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
//                       ),
//                     ),
//                   ),
//
//                   // CTA (Continue Button)
//                   SizedBox(height: 10.h),
//                   GlobalCustomButton(
//                     title: "Continue",
//                     onPressed: _onContinue,
//                   ),
//                   SizedBox(height: 14.h),
//
//                   // Terms
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         textAlign: TextAlign.center,
//                         'By continuing, you agree to our',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           color: AllColor.black.withOpacity(0.45),
//                           fontWeight: FontWeight.w500,
//                           fontFamily: "sf_Pro",
//                           height: 1.2,
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _LinkText(
//                             'Terms of service',
//                             onTap: () {/* open terms */},
//                           ),
//                           Text(
//                             ' and ',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: AllColor.black.withOpacity(0.45),
//                               fontWeight: FontWeight.w500,
//                               fontFamily: "sf_Pro",
//                               height: 1.2,
//                             ),
//                           ),
//                           _LinkText(
//                             'Privacy Policy',
//                             onTap: () {/* open privacy */},
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.h),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Slide model
// class _Slide {
//   final String svg;
//   final String title;
//   final String subtitle;
//   const _Slide({required this.svg, required this.title, required this.subtitle});
// }
//
// // Slide view widget
// class _SlideView extends StatelessWidget {
//   const _SlideView({required this.slide});
//   final _Slide slide;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Center(
//             child: Image.asset(
//               slide.svg,
//               width: 278.w,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Text(
//           slide.title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 32.sp,
//             fontWeight: FontWeight.w700,
//             color: AllColor.black,
//             fontFamily: "sf_Pro",
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           slide.subtitle,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: AllColor.black.withOpacity(0.7),
//             fontFamily: "sf_Pro",
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // Link text for terms and privacy
// class _LinkText extends StatelessWidget {
//   const _LinkText(this.text, {required this.onTap});
//   final String text;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//         child: Text(
//           text,
//           style: TextStyle(
//             decoration: TextDecoration.underline,
//             decorationColor: AllColor.black.withOpacity(0.45),
//             decorationThickness: 1.5,
//             fontSize: 14.sp,
//             color: AllColor.black.withOpacity(0.45),
//             fontFamily: "sf_Pro",
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Thin segmented progress bar (top)
// class _ProgressSegments extends StatelessWidget {
//   const _ProgressSegments({
//     required this.count,
//     required this.activeIndex,
//     required this.activeProgress,
//   });
//
//   final int count;
//   final int activeIndex;
//   final double activeProgress;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 4.h,
//       child: Row(
//         children: List.generate(count, (i) {
//           final filled = (i < activeIndex)
//               ? 1.0
//               : (i == activeIndex ? activeProgress : 0.0);
//           return Expanded(
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 2.w),
//               decoration: BoxDecoration(
//                 color: AllColor.gery,
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: FractionallySizedBox(
//                   widthFactor: filled.clamp(0, 1),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AllColor.black,
//                       borderRadius: BorderRadius.circular(2.r),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:go_router/go_router.dart';
// //
// // import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
// // import 'package:pdf_scanner/core/widget/globalCustomButton.dart';
// // import 'package:pdf_scanner/features/navbar/screen/navbar.dart';
// //
// // class OnboardingScreen extends StatefulWidget {
// //   const OnboardingScreen({super.key});
// //   static const routeName = '/onboarding';
// //
// //   @override
// //   State<OnboardingScreen> createState() => _OnboardingScreenState();
// // }
// //
// // class _OnboardingScreenState extends State<OnboardingScreen> {
// //   final _controller = PageController();
// //
// //   static const _autoDuration = Duration(seconds: 3);
// //   static const _tick = Duration(milliseconds: 50);
// //
// //   final _slides = const <_Slide>[
// //     _Slide(
// //       svg: 'assets/images/quick.png',
// //       title: 'Quick scanner in\nyour pocket',
// //       subtitle:
// //       'Scan, sign and share document with text recognition, saving in any format',
// //     ),
// //     _Slide(
// //       svg: 'assets/images/quick1.png',
// //       title: 'Conversion tool',
// //       subtitle:
// //       'Flip files easily between JPEG, TXT, and high-resolution PDF formats',
// //     ),
// //     _Slide(
// //       svg: 'assets/images/quick2.png',
// //       title: 'eSign and edit\ndocuments',
// //       subtitle:
// //       'Crop, rotate, change to black and white,\nand many other features',
// //     ),
// //     _Slide(
// //       svg: 'assets/images/scan.png',
// //       title: 'Recognises text from\n documents',
// //       subtitle:
// //       'Extract text from printed documents and \n images with precision',
// //     ),
// //   ];
// //
// //   int _index = 0;
// //   double _progress = 0;
// //   Timer? _timer;
// //   bool _dragging = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _startAuto();
// //   }
// //
// //   void _startAuto() {
// //     _timer?.cancel();
// //     _timer = Timer.periodic(_tick, (t) {
// //       if (!mounted || _dragging) return;
// //       setState(() {
// //         _progress += _tick.inMilliseconds / _autoDuration.inMilliseconds;
// //         if (_progress >= 1) {
// //           _progress = 0;
// //           final next = (_index + 1) % _slides.length;
// //           _controller.animateToPage(
// //             next,
// //             duration: const Duration(milliseconds: 350),
// //             curve: Curves.ease,
// //           );
// //         }
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   void _onContinue() {
// //     if (_index < _slides.length - 1) {
// //       _controller.nextPage(
// //         duration: const Duration(milliseconds: 350),
// //         curve: Curves.ease,
// //       );
// //     } else {
// //       // go to next screen when last slide
// //       context.go(BottomNavBar.routeName); // or SplashScreen.routeName
// //     }
// //   }
// //
// //   void _onSkip() {
// //     // skip directly to your desired screen
// //     context.go(BottomNavBar.routeName); // or BottomNavBar.routeName
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           // background image (png)
// //           Positioned.fill(
// //             child: Image.asset(
// //               'assets/images/back.png',
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //
// //           // content
// //           SafeArea(
// //             child: Padding(
// //               padding: EdgeInsets.symmetric(horizontal: 20.w),
// //               child: Column(
// //                 children: [
// //                   SizedBox(height: 8.h),
// //
// //                   // Top progress bar
// //                   _ProgressSegments(
// //                     count: _slides.length,
// //                     activeIndex: _index,
// //                     activeProgress: _progress,
// //                   ),
// //
// //                   SizedBox(height: 16.h),
// //
// //                   // Skip
// //                   Align(
// //                     alignment: Alignment.centerRight,
// //                     child: GestureDetector(
// //                       onTap: _onSkip,
// //                       child: Container(
// //                         height: 40.h,
// //                         width: 72.w,
// //                           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
// //                           decoration: BoxDecoration(
// //                             color: AllColor.gery,
// //                           borderRadius: BorderRadius.circular(30.r),
// //
// //                           ),
// //                         child: Center(
// //                           child: Text(
// //                             'Skip',
// //                             style: TextStyle(
// //                               fontSize: 17.sp,
// //                               fontWeight: FontWeight.w600,
// //                               fontFamily: "sf_Pro",
// //                               color: AllColor.black,
// //                             ),
// //                           ),
// //                         ),
// //                     ),
// //                       ),
// //
// //                   ),
// //
// //                   SizedBox(height: 10.h),
// //
// //                   // Pager
// //                   Expanded(
// //                     child: NotificationListener<UserScrollNotification>(
// //                       onNotification: (n) {
// //                         if (n.direction == ScrollDirection.idle) {
// //                           _dragging = false;
// //                           return false;
// //                         }
// //                         _dragging = true;
// //                         return false;
// //                       },
// //                       child: PageView.builder(
// //                         controller: _controller,
// //                         itemCount: _slides.length,
// //                         onPageChanged: (i) {
// //                           setState(() {
// //                             _index = i;
// //                             _progress = 0;
// //                           });
// //                         },
// //                         itemBuilder: (_, i) => _SlideView(slide: _slides[i]),
// //                       ),
// //                     ),
// //                   ),
// //
// //                   // CTA
// //                   SizedBox(height: 10.h),
// //                   GlobalCustomButton(
// //                     title: "Continue",
// //                     onPressed: _onContinue,
// //                   ),
// //                   SizedBox(height: 14.h),
// //
// //                   // Terms
// //                   Column(
// //                    mainAxisSize: MainAxisSize.min,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Text(
// //                         textAlign: TextAlign.center,
// //                         'By continuing, you agree to our',
// //                         style: TextStyle(
// //                           fontSize: 14.sp,
// //                           color: AllColor.black.withOpacity(0.45),
// //                           fontWeight: FontWeight.w500,
// //                           fontFamily: "sf_Pro",
// //                           height: 1.2,
// //                         ),
// //                       ),
// //                       // SizedBox(height: 4.h),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children:[
// //                           _LinkText(
// //                             'Terms of service',
// //                             onTap: () {/* open terms */},
// //                           ),
// //                           Text(
// //                             ' and ',
// //                             style: TextStyle(
// //                               fontSize: 14.sp,
// //                               color: AllColor.black.withOpacity(0.45),
// //                               fontWeight: FontWeight.w500,
// //                               fontFamily: "sf_Pro",
// //                               height: 1.2,
// //                             ),
// //                           ),
// //                           _LinkText(
// //                             'Privacy Policy',
// //                             onTap: () {/* open privacy */},
// //                           ),
// //
// //                         ],
// //                       ),
// //
// //                     ],
// //                   ),
// //                   SizedBox(height: 10.h),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class _Slide {
// //   final String svg;
// //   final String title;
// //   final String subtitle;
// //   const _Slide({required this.svg, required this.title, required this.subtitle});
// // }
// //
// // class _SlideView extends StatelessWidget {
// //   const _SlideView({required this.slide});
// //   final _Slide slide;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Expanded(
// //           child: Center(
// //             child:
// //
// //             Image.asset(
// //               slide.svg,
// //               width: 278.w,
// //
// //               fit: BoxFit.cover,
// //             ),
// //             // SvgPicture.asset(
// //             //   slide.svg,
// //             //   width: 278.w,
// //             //   height: 318.h,
// //             //   fit: BoxFit.cover,
// //             //
// //             // ),
// //           ),
// //         ),
// //         Text(
// //           slide.title,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             fontSize: 32.sp,
// //             fontWeight: FontWeight.w700,
// //             color:  AllColor.black,
// //             fontFamily: "sf_Pro",
// //           ),
// //         ),
// //         SizedBox(height: 8.h),
// //         Text(
// //           slide.subtitle,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             fontSize: 16.sp,
// //             color: AllColor.black.withOpacity(0.7),
// //             fontFamily: "sf_Pro",
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// //
// // class _LinkText extends StatelessWidget {
// //   const _LinkText(this.text, {required this.onTap});
// //   final String text;
// //   final VoidCallback onTap;
// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: onTap,
// //       child: Padding(
// //         padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
// //         child: Text(
// //           text,
// //           style: TextStyle(
// //             decoration: TextDecoration.underline,
// //             decorationColor: AllColor.black.withOpacity(0.45),
// //             decorationThickness: 1.5,
// //             fontSize: 14.sp,
// //             color: AllColor.black.withOpacity(0.45),
// //             fontFamily: "sf_Pro",
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // /// Thin segmented progress bar (top)
// // class _ProgressSegments extends StatelessWidget {
// //   const _ProgressSegments({
// //     required this.count,
// //     required this.activeIndex,
// //     required this.activeProgress,
// //   });
// //
// //   final int count;
// //   final int activeIndex;
// //   final double activeProgress;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SizedBox(
// //       height: 4.h,
// //       child: Row(
// //         children: List.generate(count, (i) {
// //           final filled = (i < activeIndex)
// //               ? 1.0
// //               : (i == activeIndex ? activeProgress : 0.0);
// //           return Expanded(
// //             child: Container(
// //               margin: EdgeInsets.symmetric(horizontal: 2.w),
// //               decoration: BoxDecoration(
// //                 color: AllColor.gery,
// //                 borderRadius: BorderRadius.circular(2.r),
// //               ),
// //               child: Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: FractionallySizedBox(
// //                   widthFactor: filled.clamp(0, 1),
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       color: AllColor.black,
// //                       borderRadius: BorderRadius.circular(2.r),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           );
// //         }),
// //       ),
// //     );
// //   }
// // }
