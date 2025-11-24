import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/CustomAppbar.dart';
import 'package:pdf_scanner/features/camerascanner/screen/edit_filter_screen.dart';

enum CameraCheck { camera, nonCamera }

class AutoCropScreen extends StatelessWidget {
  const AutoCropScreen({super.key, required this.cameraCheck});
  final CameraCheck cameraCheck;
  static const routeName = '/autoCropScreen';

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
        onBack: () => context.pop(),
        actions: [
          TextButton(
            onPressed: () {
              context.push(EditFilterScreen.routeName, extra: cameraCheck);
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                color: AllColor.primary,
              ),
            ),
          ),
        ],
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
                const _CropFrame(),
              ],
            ),
          ),

          /// ───────── Bottom controls ─────────
          SafeArea(
            top: false,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// page indicator pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.chevron_left,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '1/25',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AllColor.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "sf_Pro",
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Transform.rotate(
                          angle: math.pi,
                          child: Icon(
                            CupertinoIcons.chevron_left,
                            color: AllColor.white,
                            size: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// bottom actions (6 items, same style)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/auto_crop.svg",
                          label: 'Auto crop',
                          isActive: true,
                        ),
                      ),
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/retake_icon.svg",
                          label: 'Retake',
                        ),
                      ),
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/rotate_icon.svg",
                          label: 'Rotate',
                        ),
                      ),
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/tool/file-add.svg",
                          label: 'Add page',
                        ),
                      ),
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/tool/singcer.svg",
                          label: 'Signature',
                        ),
                      ),
                      Expanded(
                        child: _BottomAction(
                          imagePath: "assets/images/tool/delete.svg",
                          label: 'Delete',
                        ),
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

        // Approximate page position like the reference
        final left = w * 0.17;
        final right = w * 0.15;
        final top = h * 0.31;
        final bottom = h * 0.09;

        // function to draw a white circular handle
        Widget handle(double x, double y) {
          return Positioned(
            left: x - 8,
            top: y - 8,
            child: Container(
              width: 20.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: frameColor, width: 3),
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
            // blue rectangle border
            Positioned(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: frameColor, width: 2.5),
                ),
              ),
            ),

            // 4 corner handles
            handle(leftX, topY),
            handle(rightX, topY),
            handle(leftX, bottomY),
            handle(rightX, bottomY),

            // 4 mid-edge handles
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
  final String imagePath;
  final String label;
  final bool isActive;

  const _BottomAction({
    super.key,
    required this.imagePath,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF0A84FF);
    final Color color = isActive ? activeColor : Colors.white.withOpacity(0.85);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(imagePath),
        SizedBox(height: 4.h),
        Text(
          label,
          textAlign: TextAlign.center,
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
