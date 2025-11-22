import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/CustomAppbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DocumentPreviewScreen extends StatelessWidget {
  const DocumentPreviewScreen({super.key});

  static const String routeName = '/documentPreview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: CustomEditAppBar(
        backgroundColor: AllColor.white,
        textColor: AllColor.black,
        title: "office documents",
        centerTitle: true,
        onBack: () => context.pop(),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.more_horiz_rounded,
                color: AllColor.black,
                size: 24.sp,
              ),
              onPressed: () {

              },
            ),
          ),
        ],
      ),

      /// ───────── Body + overlays ─────────
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: ClipRRect(
                //borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  'assets/images/document.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /// page badge 3/25
          Positioned(
            right: 20.w,
            bottom: 10.h,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AllColor.gery,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                '3/25',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "sf_Pro",
                  fontWeight: FontWeight.w500,
                  color: AllColor.black,
                ),
              ),
            ),
          ),
        ],
      ),

      /// ───────── Bottom bar ─────────
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _BottomToolItem(
                    icon: Icons.add_box_outlined,
                    label: 'Add page',
                  ),
                  _BottomToolItem(
                    svgPicture: 'assets/images/pdf_edit.svg',
                    label: 'Crop',
                  ),
                  _BottomToolItem(
                    icon: Icons.drive_file_rename_outline,
                    label: 'Rename',
                  ),
                  _BottomToolItem(
                    icon: Icons.ios_share_outlined,
                    label: 'share',
                  ),
                ],
              ),

              /// ছোট navigation indicator (iOS style)
              SizedBox(height: 8.h),
              Container(
                width: 80.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _BottomToolItem extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? svgPicture;

  const _BottomToolItem({
    Key? key,
    this.icon,
    required this.label,
    this.svgPicture,
  })  : assert(icon != null || svgPicture != null,
  "Either icon or svgPicture must be provided"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Icon or SVG
          if (svgPicture != null)
            SvgPicture.asset(
              svgPicture!,
              height: 24.sp,
              width: 24.sp,
              color: AllColor.black,
            )
          else if (icon != null)
            Icon(
              icon,
              size: 24.sp,
              color: AllColor.black,
            ),

          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: "sf_Pro",
              fontWeight: FontWeight.w500,
              color: AllColor.black,
            ),
          ),
        ],
      ),
    );
  }
}
