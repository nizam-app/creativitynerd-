import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/core/widget/global_deals_banner.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/marge_pdf_45.dart';
import 'package:pdf_scanner/features/tools/screen/model/document_list_model.dart';
import 'package:pdf_scanner/features/tools/screen/model/shahre_sestion_model.dart';
import 'package:pdf_scanner/features/tools/widget/custom_document_list.dart';
import 'package:pdf_scanner/features/tools/widget/custom_top_back_button.dart';

// extension ScreenNameLabel on ScreenName {
//   String get label {
//     switch (this) {
//       case ScreenName.marge:
//         return "merged";
//       case ScreenName.split:
//         return "split";
//       case ScreenName.lock:
//         return "locked";
//     }
//   }
// }
class CongratulationsScreen extends StatelessWidget {
  static final routeName = '/congratulationsScreen';
  final ScreenName isCheckScreenName;
  const CongratulationsScreen({super.key, required this.isCheckScreenName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBarBackButton(title: '', icon: Icons.home_outlined),
            ConraculationTap(
              screenName: isCheckScreenName,
              image: SvgPicture.asset('assets/images/tool/verify.svg'),
            ),
            CustomDocumentList(
              documents: [
                DocumentItem(
                  title: '04 Aug, document 3',
                  pages: 8,
                  size: '120 KB',
                ),
              ],
              isMyDeviceShow: false,
              showArrow: true,
              onDocumentTap: (doc) {},
            ) ,
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.h),
              child: CustomShareOpen(
                onShare: () {
                  // share logic
                },
                onOpen: () {
                  // open pdf logic
                },
              ),
            ),
            SizedBox(height: 10.h,)          ,
            _ShareSestion(
              items: [
                ShareActionItem(
                  icon: SvgPicture.asset('assets/images/tool/icon_rename.svg', width: 28, height: 28),
                  label: 'Rename',
                  onTap: () {
                    // rename logic
                  },
                ),
                ShareActionItem(
                  icon:SvgPicture.asset('assets/images/tool/icon_create_new.svg', width: 28, height: 28),
                  label: 'New Create',
                  onTap: () {
                    // new create logic
                  },
                ),
                ShareActionItem(
                  icon:SvgPicture.asset('assets/images/tool/icon_whatsapp.svg', width: 28, height: 28),
                  label: 'WhatsApp',
                  onTap: () {
                    // whatsapp share
                  },
                ),
                ShareActionItem(
                  icon:SvgPicture.asset('assets/images/tool/icon_tools.svg', width: 28, height: 28),
                  label: 'Tools',
                  onTap: () {
                    // open tools
                  },
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.r),
              child: GlobalDealsBanner(),
            ),
          ],
        ),
      ),
    );
  }
}

class ConraculationTap extends StatelessWidget {
  final Widget image; // 🔹 তোমার দেওয়া image এখানে আসবে
  final String title;
  final String message;
  final ScreenName screenName;

  const ConraculationTap({
    super.key,
    required this.screenName,
    required this.image,
    this.title = 'Congratulations',
    this.message = 'Your PDF has been successfully',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),

        // ---------- Top Image ----------
        SizedBox(
          width: 125.w,
          height: 125.03.w,
          child: FittedBox(fit: BoxFit.contain, child: image),
        ),

        SizedBox(height: 24.h),
        SizedBox(
          width: 360.w,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp, 
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1C),
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Your PDF has been successfully ${screenName.name}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6E7780),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomShareOpen extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onOpen;

  const CustomShareOpen({
    super.key,
    this.onShare,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Share button
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: onShare,
              child: Text(
                'Share',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Open button
        Expanded(
          child: SizedBox(
            height: 40.h,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color(0xFF4E6BFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: onOpen,
              child: Text(
                'Open',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _ShareSestion extends StatelessWidget {
  final List<ShareActionItem> items;

  const _ShareSestion({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F7FB), // হালকা ব্যাকগ্রাউন্ড, স্ক্রিনশটের মতো
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .map(
              (e) => _ShareActionTile(
            icon: e.icon,
            label: e.label,
            onTap: e.onTap,
          ),
        )
            .toList(),
      ),
    );
  }
}

class _ShareActionTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const _ShareActionTile({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Container(
            width: 80.w,
            height: 60.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  size: 26.sp,
                  color: const Color(0xFF707070), // grey icon
                ),
                child: icon,
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5A5A5A),
            ),
          ),
        ),
      ],
    );
  }
}