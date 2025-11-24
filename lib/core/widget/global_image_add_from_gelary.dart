import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/camerascanner/screen/camera_screen.dart';

import '../../features/tools/screen/auto_crop_screen.dart';

void globalShowAddSheet(
  BuildContext context, {
  bool isCheckInTwoOption = true,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.w,
          8.h,
          16.w,
          16.h + MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: _ActionTile(
                svg: 'assets/images/photos.svg', // 🟡 update your asset paths
                label: 'Import from\nPhotos',
                onTap: () {}, // TODO
              ),
            ),
            SizedBox(width: 12.w),
            if (isCheckInTwoOption)
              Expanded(
                child: _ActionTile(
                  svg: 'assets/images/files.svg',
                  label: 'Import from\nfiles',
                  onTap: () {},
                ),
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionTile(
                svg: 'assets/images/camera.svg',
                label: 'Scan\nDocument',
                onTap: () {
                  if (isCheckInTwoOption == true)
                    context.push(CameraScreen.routeName);
                  else
                    context.push(
                      AutoCropScreen.routeName,
                      extra: CameraCheck.nonCamera,
                    );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.svg, required this.label, this.onTap});

  final String svg;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: AllColor.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AllColor.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svg,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AllColor.black,
                height: 1.2,
                fontFamily: "sf_Pro",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
