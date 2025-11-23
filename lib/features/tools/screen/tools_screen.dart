import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/upgrade_plan_card.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/marge_pdf_45.dart';

class ToolItem {
  final String title;
  final String svgAsset;
  final Color cardColor;
  final Color iconBg;
  final VoidCallback onTap;
  final bool isPremium; // 🔹 শুধু Unlock PDF এর জন্য true

  ToolItem({
    required this.title,
    required this.svgAsset,
    required this.cardColor,
    required this.iconBg,
    required this.onTap,
    this.isPremium = false, // ডিফল্ট false
  });
}

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({Key? key}) : super(key: key);
  static const String routeName = '/toolsScreen';
  //dskfsd
  @override
  Widget build(BuildContext context) {
    final tools = <ToolItem>[
      ToolItem(
        title: 'Merge PDF',
        svgAsset: 'assets/images/mergepdf.svg',
        cardColor: const Color(0xFFE6F2FF),
        iconBg: const Color(0xFF4C9BFF),
        onTap: () {
          context.push(MargePdf45.routeName,extra: ScreenName.marge);
        },
      ),
      ToolItem(
        title: 'Split PDF',
        svgAsset: 'assets/images/splitpdf.svg',
        cardColor: const Color(0xFFE7F7E9),
        iconBg: const Color(0xFF52B46E),
        onTap: () {context.push(MargePdf45.routeName,extra: ScreenName.split);},
      ),
      ToolItem(
        title: 'Image to PDF',
        svgAsset: 'assets/images/image_pdf.svg',
        cardColor: const Color(0xFFFFEEE5),
        iconBg: const Color(0xFFFA8642),
        onTap: () {},
      ),
      ToolItem(
        title: 'Lock PDF',
        svgAsset: 'assets/images/lock.svg',
        cardColor: const Color(0xFFFFF1DB),
        iconBg: const Color(0xFFF6B348),
        onTap: () {context.push(MargePdf45.routeName,extra: ScreenName.lock);},
      ),
      ToolItem(
        title: 'Unlock PDF',
        svgAsset: 'assets/images/unlock.svg',
        cardColor: const Color(0xFFE7ECF6),
        iconBg: const Color(0xFF6173AA),
        isPremium: true,
        onTap: () {context.push(MargePdf45.routeName,extra: ScreenName.unlock);},
      ),
      ToolItem(
        title: 'Extract Text',
        svgAsset: 'assets/images/icons.svg',
        cardColor: const Color(0xFFEFE6FF),
        iconBg: const Color(0xFF8C4CFF),
        onTap: () {},
      ),
      ToolItem(
        title: 'Add Signature',
        svgAsset: 'assets/images/signature.svg',
        cardColor: const Color(0xFFEDEDED),
        iconBg: const Color(0xFF919191),
        onTap: () {},
      ),
      ToolItem(
        title: 'QR Scan',
        svgAsset: 'assets/images/qrcode.svg',
        cardColor: const Color(0xFFE7F5FF),
        iconBg: const Color(0xFF4C9BFF),
        onTap: () {},
      ),
      ToolItem(
        title: 'ID Card Scan',
        svgAsset: 'assets/images/card.svg',
        cardColor: const Color(0xFFE6F7EC),
        iconBg: const Color(0xFF27AE60),
        onTap: () {},
      ),
      ToolItem(
        title: 'Doc Scan',
        svgAsset: 'assets/images/doc.svg',
        cardColor: const Color(0xFFEDE6FF),
        iconBg: const Color(0xFF8C4CFF),
        onTap: () {},
      ),
      ToolItem(
        title: 'Book Scan',
        svgAsset: 'assets/images/vector_book.svg',
        cardColor: const Color(0xFFE5F7F9),
        iconBg: const Color(0xFF1ABC9C),
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tools',
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                ),
              ),

              const UpgradePlanCard(),

              SizedBox(height: 20.h),
              SizedBox(height: 24.h),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tools.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  return ToolCard(item: tool);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single tool card
class ToolCard extends StatelessWidget {
  final ToolItem item;

  const ToolCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.cardColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: item.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (item.isPremium)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(2.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SvgPicture.asset(
                      "assets/images/premium.svg", // premium.svg / pdf icon
                      width: 18.w,
                      height: 18.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                SizedBox(height: 18.h), // height balance রাখার জন্য

              SvgPicture.asset(
                item.svgAsset,
                width: 34.w,
                height: 34.h,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10.h),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: "sf_Pro",
                  fontWeight: FontWeight.w400,
                  color: AllColor.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}