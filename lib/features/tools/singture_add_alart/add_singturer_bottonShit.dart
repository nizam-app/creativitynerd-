import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _kPrimaryBlue = Color(0xFF657DF2);

enum SignatureMenuAction { camera, gallery, draw }

void showSignatureBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => const _SignatureBottomSheet(),
  );
}

class _SignatureBottomSheet extends StatelessWidget {
  const _SignatureBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: media.padding.bottom, // bottom gesture area
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FF),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Signature',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF262626),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 60.w), // Cancel এর জায়গা balance করার জন্য
                ],
              ),

              SizedBox(height: 14.h),

              // ───────── Add Signature box (dashed) ─────────
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(14.r),
                color: const Color(0xFFCBD2E7), // light grey dashed
                strokeWidth: 1,
                dashPattern: const [6, 4], // dash length 6, gap 4
                child: Container(
                  height: 64.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Signature',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1C1E),
                        ),
                      ),
                      const Icon(Icons.add, size: 22, color: Color(0xFF1C1C1E)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ───────── Saved signatures list ─────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Column(
                  children: const [
                    _SignaturePreviewItem(
                      imagePath: 'assets/images/signature_1.png',
                    ),
                    SizedBox(height: 12),
                    _SignaturePreviewItem(
                      imagePath: 'assets/images/signature_2.png',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// popup menu item
PopupMenuItem<SignatureMenuAction> _buildMenuItem(
  BuildContext context, {
  required IconData icon,
  required String text,
  required SignatureMenuAction value,
}) {
  return PopupMenuItem<SignatureMenuAction>(
    value: value,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xFF111111)),
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF111111),
          ),
        ),
      ],
    ),
  );
}

/// single saved-signature row (white card)
class _SignaturePreviewItem extends StatelessWidget {
  final String imagePath;

  const _SignaturePreviewItem({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Image.asset(imagePath, height: 32.h, fit: BoxFit.contain),
      ),
    );
  }
}
