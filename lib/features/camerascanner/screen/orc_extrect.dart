import 'package:flutter/material.dart';
import '../../../core/constants/color_control/all_color.dart';
import '../../../core/widget/CustomAppbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/processingPopup.dart';

class OrcExtrect extends StatelessWidget {
  const OrcExtrect({super.key});
  static const routeName = '/orcExtrect';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomEditAppBar(
        backgroundColor: AllColor.black,
        textColor: AllColor.white,
        title: "OCR Extrect ",
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ProcessingPopup.show(context);
            },
            child: Text(
              "Done",
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
                  /// bottom actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BottomAction(
                        svgAsset: 'assets/images/copy_icon.svg',
                        label: 'Copy',
                        isActive: true,
                      ),

                      _BottomAction(
                        svgAsset: 'assets/images/edit_icon.svg',
                        label: 'Edit',
                        isActive: false,
                      ),

                      _BottomAction(
                        svgAsset: 'assets/images/export_icon.svg',
                        label: 'Export',
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
        final left = w * 0.20;
        final right = w * 0.14;
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
  final String svgAsset; // e.g. 'assets/images/crop.svg'
  final String label;
  final bool isActive;
  final double size;

  const _BottomAction({
    Key? key,
    required this.svgAsset,
    required this.label,
    this.isActive = false,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0A84FF) : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgAsset,
          width: size.sp,
          height: size.sp,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
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
