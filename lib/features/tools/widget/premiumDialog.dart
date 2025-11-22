
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/onbording/widget/CustomButton.dart';

void showPremiumBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // corner rounded রাখতে
    builder: (_) => const Premiumdialog(),
  );
}

class Premiumdialog extends StatelessWidget {
  const Premiumdialog({super.key});

  @override
  Widget build(BuildContext context) {
    return
      // Padding(
      // padding: EdgeInsets.only(
      //   left: 10.w,
      //   right: 10.w,
      //   //bottom: 16.h + MediaQuery.of(context).viewInsets.bottom,
      // ),
      // child:
    Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120.h, // চাইলে 120.h/150.h রাখতে পারো
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFED4FF),
                          Color(0xFFB38CFF),
                        ],
                        // begin: Alignment.topLeft,
                        // end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 10.h,
                        ),
                        child: Image.asset(
                          'assets/images/box.png',
                          height: 110.h,
                          width: 110.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Unlock Premium Features',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sf_Pro',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: AllColor.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Subscribe now for unlimited access to\npremium features\nor\nWatch a short video to unlock premium feature.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sf_Pro',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 18.h),

                        // Subscribe Now button

                        Container(
                            width: 235.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              border: Border.all(width: 1.w, color: AllColor.primary)
                            ),
                            child: CustomButton(backgroundColor: AllColor.white,textColor: AllColor.primary,  text: "Subscribe Now", onPressed: (){})),

                        SizedBox(height: 10.h),

                        // Container(
                        //     width: 235.h,
                        //
                        //     child: CustomButton(backgroundColor: AllColor.primary,textColor: AllColor.white,  text: "Watch Video", onPressed: (){})),
                        //

                        // Watch Video button
                        SizedBox(
                          width: 235.w,
                          height: 60.h,

                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: watch ad action
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AllColor.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFC94A),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    'Ad',
                                    style: TextStyle(
                                      fontFamily: 'sf_Pro',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AllColor.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Watch Video',
                                  style: TextStyle(
                                    fontFamily: 'sf_Pro',
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AllColor.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),

              // Close (X) button
              Positioned(
                right: 10.w,
                top: 10.h,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}
