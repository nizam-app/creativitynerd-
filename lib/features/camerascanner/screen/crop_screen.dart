import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/widget/CustomAppbar.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_save_screen.dart';
import '../../../core/constants/color_control/all_color.dart';
import 'package:go_router/go_router.dart';

class CropScreen extends StatelessWidget {
  const CropScreen({super.key});
  static const routeName = '/cropScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// ───────── AppBar ─────────
      appBar: CustomEditAppBar(
        backgroundColor: AllColor.black,
        textColor: AllColor.white,
        title: "Crop",
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () {
              context.push(CropSaveScreen.routeName);
            },
            child: Text(
              "Save",
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: AllColor.primary,
              ),
            ),
          ),
        ],

        onBack: () => context.pop(),
      ),

      body: Column(
        children: [
          /// ───────── FULLSCREEN IMAGE + CROP FRAME ─────────
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/camera_image.png',
                  fit: BoxFit.cover,
                ),

                // কেবল বইয়ের পেজের ওপর crop-frame
                const _CropFrame(),
              ],
            ),
          ),

          /// ───────── Bottom controls ─────────
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// page indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '1/25',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AllColor.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "sf_Pro",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Transform.rotate(
                          angle: math.pi,
                          child: Icon(
                            CupertinoIcons.back,
                            color: AllColor.white,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h),

                  /// bottom actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BottomAction(
                        icon: Icons.rotate_90_degrees_ccw_outlined,
                        label: 'Rotate',
                        isActive: false,
                      ),
                      _BottomAction(
                        icon: CupertinoIcons.crop,
                        label: 'Auto crop',
                        isActive: true, // middle one blue
                      ),
                      _BottomAction(
                        icon: Icons.fullscreen_outlined,
                        label: 'Full',
                        isActive: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────── Crop frame overlay ─────────────────
class _CropFrame extends StatelessWidget {
  const _CropFrame();

  @override
  Widget build(BuildContext context) {
    const frameColor = Color(0xFF0A84FF);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;


        final left = w * 0.18;
        final right = w * 0.16;
        final top = h * 0.3;
        final bottom = h * 0.10;

        Widget handle(double x, double y) {
          return Positioned(
            left: x - 7,
            top: y - 7,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: frameColor, width: 2),
              ),
            ),
          );
        }

        final leftX = left;
        final rightX = w - right;
        final topY = top;
        final bottomY = h - bottom;
        final midX = (leftX + rightX) / 2;
        final midY = (topY + bottomY) / 2;

        return Stack(
          children: [
            // blue rectangle
            Positioned(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: frameColor, width: 2),
                ),
              ),
            ),

            // 4 corner handles
            handle(leftX, topY),
            handle(rightX, topY),
            handle(leftX, bottomY),
            handle(rightX, bottomY),

            // mid-edge handles
            handle(midX, topY),
            handle(midX, bottomY),
            handle(leftX, midY),
            handle(rightX, midY),
          ],
        );
      },
    );
  }
}

/// ───────────────── Bottom action button ─────────────────
class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomAction({
    Key? key,
    required this.icon,
    required this.label,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0A84FF) : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: color,
            fontFamily: "sf_Pro",
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
