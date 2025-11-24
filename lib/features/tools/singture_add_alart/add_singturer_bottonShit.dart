import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const Color _kPrimaryBlue = Color(0xFF657DF2);

void showSignatureBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => const _SignatureSheet(),
  );
}

/// ----------------- Main bottom sheet -----------------
class _SignatureSheet extends StatelessWidget {
  const _SignatureSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return FractionallySizedBox(
      heightFactor: 0.30,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // main white card
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 12.h,
                bottom: media.padding.bottom + 16.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header
                  Row(
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8E8E93),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Signature',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: const Color(0xFF1C1C1E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Add signature row
                  _AddSignatureRow(),
                  SizedBox(height: 24.h),

                  // bottom handle
                  Container(
                    width: 120.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------- Add signature row -----------------
class _AddSignatureRow extends StatelessWidget {
  const _AddSignatureRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFD3D7E3),
          width: 1,
          // 🔸 dashed চাইলে DottedBorder প্যাকেজ ইউজ করো
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Text(
            'Add Signature',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF111111),
            ),
          ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              _showSignatureOptionsMenu(context, details.globalPosition);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Icon(
                CupertinoIcons.add,
                size: 22.sp,
                color: const Color(0xFF111111),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------- Floating submenu (Camera / Gallery / Draw) -----------------
void _showSignatureOptionsMenu(BuildContext context, Offset tapPosition) {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  final overlaySize = overlay.size;

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogCtx) {
      return Stack(
        children: [
          // background tap to close
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(dialogCtx).pop(),
              child: Container(color: Colors.transparent),
            ),
          ),

          // popover – slightly above Add Signature row, right side
          Positioned(
            right: 24.w,
            top: overlaySize.height * 0.32,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 240.w,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SignatureOptionRow(
                      icon: Icons.photo_camera_outlined,
                      label: 'Camera',
                      onTap: () {
                        Navigator.of(dialogCtx).pop();
                        // TODO: camera action
                      },
                    ),
                    _DividerLine(),
                    _SignatureOptionRow(
                      icon: Icons.photo_library_outlined,
                      label: 'Import from gallery',
                      onTap: () {
                        Navigator.of(dialogCtx).pop();
                        // TODO: gallery action
                      },
                    ),
                    _DividerLine(),
                    _SignatureOptionRow(
                      icon: Icons.edit_outlined,
                      label: 'Draw',
                      onTap: () {
                        Navigator.of(dialogCtx).pop();
                        // TODO: draw action
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _SignatureOptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SignatureOptionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: const Color(0xFF3A3A3C)),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF111111),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      color: const Color(0xFFE4E5EC),
    );
  }
}
