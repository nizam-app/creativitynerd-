import 'package:flutter/material.dart';
import '../../../core/constants/color_control/all_color.dart';
import '../../../core/constants/color_control/tool_flow_color.dart';
import '../../../core/widget/CustomAppbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../settings/widget/lagnuage.dart';

class OrcExtrect extends StatelessWidget {
   OrcExtrect({super.key});
  static const routeName = '/orcExtrect';

  LanguageOption _selectedLanguage = LanguageOption(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flagAsset: 'assets/flags/us.png',
  );

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
              ExtractedTextPopup.show(
                context,
                extractedText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                language: "English",
                onLanguageTap: () {
                  LanguageSelectionScreen(
                    selected: _selectedLanguage,
                  );
                },
              );
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

                //const _CropFrame(),
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
                        isActive: false,
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


class ExtractedTextPopup {
  static Future<void> show(
      BuildContext context, {
        required String extractedText,
        String language = "English",
        VoidCallback? onLanguageTap,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) {
        return SafeArea(
          top: false,
          child: _ExtractedTextSheet(
            extractedText: extractedText,
            language: language,
            onLanguageTap: onLanguageTap,
          ),
        );
      },
    );
  }
}

class _ExtractedTextSheet extends StatelessWidget {
  final String extractedText;
  final String language;
  final VoidCallback? onLanguageTap;

  const _ExtractedTextSheet({
    required this.extractedText,
    required this.language,
    this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // bottom safe area
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8.h,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        child: Container(
          color:  ToolFlowColor.backGroundColor, // sheet background
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              SizedBox(height: 8.h),
              Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 10.h),

              // main card
              Container(
                margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 12.h),
                decoration: BoxDecoration(
                  color: AllColor.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: const Color(0xFFE2E4EA),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // header
                    Container(
                      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F7), // light gray header
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Extracted Text",
                            style: TextStyle(
                              fontFamily: "sf_Pro",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: AllColor.black,
                            ),
                          ),
                          const Spacer(),
                          _LanguagePill(
                            language: language,
                            onTap: onLanguageTap,
                          ),
                        ],
                      ),
                    ),

                    // divider
                    Container(
                      height: 1.h,
                      color: const Color(0xFFE7E9EE),
                    ),

                    // body text area
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                      constraints: BoxConstraints(minHeight: 150.h),
                      color: AllColor.white,
                      child: Text(
                        extractedText,
                        style: TextStyle(
                          fontFamily: "sf_Pro",
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: AllColor.black,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String language;
  final VoidCallback? onTap;

  const _LanguagePill({
    required this.language,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AllColor.primary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.globe,
              size: 18.sp,
              color: AllColor.white,
            ),
            SizedBox(width: 6.w),
            Text(
              language,
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AllColor.white,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: AllColor.white,
            ),
          ],
        ),
      ),
    );
  }
}


