import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';

class CustomBarcodeDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return const _BarcodeIOSDialog();
      },
    );
  }
}

class _BarcodeIOSDialog extends StatefulWidget {
  const _BarcodeIOSDialog({Key? key}) : super(key: key);

  @override
  State<_BarcodeIOSDialog> createState() => _BarcodeIOSDialogState();
}

class _BarcodeIOSDialogState extends State<_BarcodeIOSDialog> {
  int selected = 1;
  final controller = TextEditingController(text: "0123456789");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Material(
            color: Colors.white.withOpacity(0.85),
            child: Container(
              width: 280.w,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// Title
                  Text(
                    "Barcode",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "sf_Pro",
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  /// TextField
                  TextField(

                    style: TextStyle(
                        fontSize: 11.sp,
                        color: AllColor.borderColor.withOpacity(0.55),
                        fontFamily: "sf_Pro",
                        fontWeight: FontWeight.w400
                    ),
                    controller: controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AllColor.white,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: AllColor.white),
                      ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(10.r),
                      //   borderSide: BorderSide(color: AllColor.primary),
                      // ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Radio Buttons (iOS style)
                  _iosRadioTile(
                    title: "Open in browser app",
                    value: 1,
                  ),
                  _iosRadioTile(
                    title: "See more apps to open this scan",
                    value: 2,
                  ),

                   SizedBox(height: 10.h),

                  /// Divider Top
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AllColor.borderColor.withOpacity(0.55),
                  ),

                  /// Bottom Buttons with CENTER DIVIDER
                  SizedBox(
                    height: 44.h,
                    child: Row(
                      children: [
                        /// Cancel
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: AllColor.primary,
                                  fontFamily: "sf_Pro",
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Vertical Divider
                        Container(
                          width: 1,
                          color: AllColor.borderColor.withOpacity(0.55),
                        ),

                        /// Ok
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: AllColor.primary,
                                  fontFamily: "sf_Pro",
                                  fontWeight: FontWeight.w600
                                ),
                              ),
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
        ),
      ),
    );
  }

  /// Custom iOS Radio Row
  Widget _iosRadioTile({required String title, required int value}) {
    return InkWell(
      onTap: () => setState(() => selected = value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            Icon(
              selected == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected == value ? AllColor.primary : AllColor.borderColor.withOpacity(0.55),
              size: 20.sp,
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                  fontWeight: FontWeight.w400,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
