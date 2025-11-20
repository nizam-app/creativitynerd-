import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/widget/CustomAppbar.dart';
import 'package:pdf_scanner/features/camerascanner/screen/documentPreviewScreen.dart';
import 'package:pdf_scanner/features/onbording/widget/CustomButton.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CropSaveScreen extends StatefulWidget {
  const CropSaveScreen({super.key});

  static const routeName = '/cropSaveScreen';

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
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.grid_view_outlined,
                color: AllColor.white,
                size: 24.sp,
              ),
              onPressed: () {

              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
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
                      child: Container(
                        width: 340.w,
                        height: 460.h,
                        // approximate letter page
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.asset(
                            'assets/images/pdfsaveImages.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
        
              // BOTTOM PANtaiEL
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
                                horizontal: 12.w, vertical: 3.h),
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
        
                      // Tool buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _BottomToolButton(
                            svgPath: 'assets/images/retake_icon.svg',
                            label: 'Retake',
                          ),
                          _BottomToolButton(
                            svgPath: 'assets/images/signature.svg',
                            label: 'Signature',
                          ),
                          _BottomToolButton(
                            svgPath: 'assets/images/watermark.svg',
                            label: 'Watermark',
                          ),
                          _BottomToolButton(
                            svgPath: 'assets/images/add_text.svg',
                            label: 'Add text',
                          ),
                          _BottomToolButton(
                            svgPath: 'assets/images/highlight.svg',
                            label: 'Highlight',
                          ),
                          _BottomToolButton(
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
                            child: CustomButton(text: "Cancel",textColor: AllColor.white, backgroundColor: AllColor.gery100, onPressed: (){
                              context.pop();
                            }),
                          ),
                            SizedBox(width: 12.w,),
                            Expanded(
                              child: CustomButton(
                                  text: "Save PDF",textColor: AllColor.white,
                                  backgroundColor: AllColor.primary,
                                  onPressed: (){
                                    context.push(DocumentPreviewScreen.routeName);
                              }),
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


  const _BottomToolButton({
    required this.svgPath,
    required this.label,
    // optional size
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
