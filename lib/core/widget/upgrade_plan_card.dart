import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';

import '../../features/tools/widget/premiumDialog.dart';
import 'package:go_router/go_router.dart';

class UpgradePlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconAsset;
  final VoidCallback? onTap;

  const UpgradePlanCard({
    Key? key,
    this.title = 'Upgrade Plan Now!',
    this.subtitle = 'Enjoy all the benefits and explore more possibilities',
    this.iconAsset = 'assets/images/injoy.svg',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16.r),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: (){
          showPremiumBottomSheet(context);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF4A6CFF) ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // color: AllColor.gery, // চাইলে আবার active করতে পারো
                ),
                child: SvgPicture.asset(
                  iconAsset,
                  width: 60.sp,
                  height: 60.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AllColor.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "sf_Pro",
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AllColor.white,
                        fontSize: 10.sp,
                        fontFamily: "sf_Pro",
                        fontWeight: FontWeight.w500,
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
