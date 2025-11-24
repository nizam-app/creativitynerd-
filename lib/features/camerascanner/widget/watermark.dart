import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';

import '../../../core/constants/color_control/tool_flow_color.dart';


Future<String?> showAddTextBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddTextBottomSheet(),
  );
}

class _AddTextBottomSheet extends StatefulWidget {
  const _AddTextBottomSheet({super.key});

  @override
  State<_AddTextBottomSheet> createState() => _AddTextBottomSheetState();
}

class _AddTextBottomSheetState extends State<_AddTextBottomSheet> {
  double _fontSize = 12;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        // make sheet go above keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ToolFlowColor.backGroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------------- TOP BAR ----------------
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'sf_Pro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: AllColor.borderColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Add text',
                      style: TextStyle(
                        fontFamily: 'sf_Pro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AllColor.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, _controller.text),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'sf_Pro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AllColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // ---------------- TOP CONTROLS ROW ----------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Align dropdown
                      _SegmentBox(
                        child: Row(
                          children: [
                            Icon(Icons.format_align_left,
                                size: 20.sp, color: AllColor.black),
                            SizedBox(width: 6.w),
                            Icon(Icons.keyboard_arrow_down,
                                size: 16.sp, color: AllColor.primary),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Font size with - 12 pt +
                      _SegmentBox(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_fontSize > 8) _fontSize--;
                                });
                              },
                              child: Icon(Icons.remove,
                                  size: 16.sp, color: AllColor.primary),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${_fontSize.toInt()} pt',
                              style: TextStyle(
                                fontFamily: 'sf_Pro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AllColor.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _fontSize++;
                                });
                              },
                              child: Icon(Icons.add,
                                  size: 16.sp, color: AllColor.primary),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Font family dropdown
                      _SegmentBox(
                        child: Row(
                          children: [
                            Text(
                              'SF Pro',
                              style: TextStyle(
                                fontFamily: 'sf_Pro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AllColor.black,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(Icons.keyboard_arrow_down,
                                size: 16.sp, color: AllColor.primary),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ColorCircleDropdownIcon(),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                // ---------------- TEXT AREA ----------------
                Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 10.h),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontFamily: 'sf_Pro',
                        fontSize: _fontSize.sp,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type here',
                        hintStyle: TextStyle(
                          fontFamily: 'sf_Pro',
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorCircleDropdownIcon extends StatelessWidget {
  const ColorCircleDropdownIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer black ring
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.black,
            ),
          ),

          // White ring
          Container(
            width: 28.w,
            height: 28.w,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.white,
            ),
          ),

          // Inner black filled circle
          Container(
            width: 22.w,
            height: 22.w,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.black,
            ),
          ),

          // Blue V arrow
          Transform.rotate(
            angle: math.pi,
            child: Icon(
              Icons.expand_less,
              size: 14.sp,
              color:  AllColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}


/// Small rounded white segment like the screenshot controls row
class _SegmentBox extends StatelessWidget {
  final Widget child;
  final double? width;

  const _SegmentBox({
    required this.child,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AllColor.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFFE2E3E7),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset:  Offset(0, 1),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
