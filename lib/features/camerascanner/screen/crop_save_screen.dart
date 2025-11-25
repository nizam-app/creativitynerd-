import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/CustomAppbar.dart';
import 'package:pdf_scanner/features/camerascanner/screen/documentPreviewScreen.dart';
import 'package:pdf_scanner/features/onbording/widget/CustomButton.dart';
import 'package:pdf_scanner/features/tools/signature/add_singturer_bottonShit.dart';

import '../widget/watermark.dart';

class CropSaveScreen extends StatefulWidget {
  static const routeName = '/cropSaveScreen';

  /// ApplySignatureScreen theke jodi merged image ashe
  final Uint8List? signedDocBytes;

  const CropSaveScreen({super.key, this.signedDocBytes});

  @override
  State<CropSaveScreen> createState() => _CropSaveScreenState();
}

class _CropSaveScreenState extends State<CropSaveScreen> {
  int _currentPage = 1;
  int _totalPages = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.black,
      appBar: CustomEditAppBar(
        backgroundColor: AllColor.black,
        textColor: AllColor.white,
        title: "PDFScanner10-18-2025",
        centerTitle: true,
        onBack: () => context.pop(),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.grid_view_outlined,
                color: AllColor.white,
                size: 24.sp,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(
                Icons.more_horiz_rounded,
                color: AllColor.white,
                size: 24.sp,
              ),
              onPressed: () {
                // TODO: more action
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: SizedBox(
                    width: 340.w,
                    height: 460.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      // ✅ jodi ApplySignatureScreen theke image ase
                      // tahole oita use hobe, otherwise old asset
                      child: widget.signedDocBytes != null
                          ? Image.memory(
                              widget.signedDocBytes!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/pdfsaveImages.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),

              // BOTTOM PANEL
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF050505),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AllColor.gery100,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: AllColor.gery100,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      if (_currentPage > 1) _currentPage--;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 24.sp,
                                    color: AllColor.white,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '$_currentPage/$_totalPages',
                                  style: TextStyle(
                                    fontFamily: 'sf_Pro',
                                    color: AllColor.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      if (_currentPage < _totalPages) {
                                        _currentPage++;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 24.sp,
                                    color: AllColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _BottomToolButton(
                            svgPath: 'assets/images/retake_icon.svg',
                            label: 'Retake',
                            onTap: () {},
                          ),
                          _BottomToolButton(
                            svgPath: 'assets/images/signature.svg',
                            label: 'Signature',
                            onTap: () {
                              showSignatureBottomSheet(context);
                            },
                          ),
                          _BottomToolButton(
                            onTap: () async {
                              context.push(WatermarkScreen.routeName);
                            },
                            svgPath: 'assets/images/watermark.svg',
                            label: 'Watermark',
                          ),
                          _BottomToolButton(
                            onTap: () {},
                            svgPath: 'assets/images/add_text.svg',
                            label: 'Add text',
                          ),
                          _BottomToolButton(
                            onTap: () {},
                            svgPath: 'assets/images/highlight.svg',
                            label: 'Highlight',
                          ),
                          _BottomToolButton(
                            onTap: () {},
                            svgPath: 'assets/images/filter.svg',
                            label: 'Filter',
                          ),
                        ],
                      ),

                      SizedBox(height: 18.h),

                      // Bottom buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Cancel",
                              textColor: AllColor.white,
                              backgroundColor: AllColor.gery100,
                              onPressed: () {
                                context.pop();
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomButton(
                              text: "Save PDF",
                              textColor: AllColor.white,
                              backgroundColor: AllColor.primary,
                              onPressed: () {
                                context.push(DocumentPreviewScreen.routeName);
                              },
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
        ),
      ),
    );
  }
}

class _BottomToolButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final VoidCallback? onTap;

  const _BottomToolButton({
    required this.svgPath,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            svgPath,
            color: AllColor.white,
            height: 24.h,
            width: 24.w,
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'sf_Pro',
              color: AllColor.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
