import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/features/tools/signature/signature_draw_screen.dart';

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

/// ───────────────── BottomSheet ─────────────────
class _SignatureBottomSheet extends StatefulWidget {
  const _SignatureBottomSheet({super.key});

  @override
  State<_SignatureBottomSheet> createState() => _SignatureBottomSheetState();
}

class _SignatureBottomSheetState extends State<_SignatureBottomSheet> {
  /// এখানে dynamic ভাবে signature path রাখবে
  /// শুরুতে খালি থাকলে নিচের white box একদমই দেখাবে না
  final List<String> _signatures = [];

  Future<void> _onMenuAction(SignatureMenuAction? action) async {
    if (action == null) return;

    // TODO: এখানে আসল camera / gallery / draw logic বসাবে

    setState(() {
      _signatures.add('assets/images/signature_1.png');
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: media.padding.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ───────── header (Cancel | Signature) ─────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17.sp,
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
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF616263),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 60.w),
                ],
              ),

              SizedBox(height: 14.h),

              /// ───────── Add Signature box (dashed) + plus menu ─────────
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(14.r),
                color: Colors.black.withOpacity(.22),
                strokeWidth: 1,
                dashPattern: const [6, 4],
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
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1C1C1E),
                        ),
                      ),

                      /// ➕ আইকনে ক্লিক করলে উপরে submenu popup হবে
                      Builder(
                        builder: (btnCtx) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (details) async {
                              final overlay =
                                  Overlay.of(btnCtx).context.findRenderObject()
                                      as RenderBox;

                              // menu টা একটু উপরে দেখানোর জন্য rect বানাচ্ছি
                              final position = RelativeRect.fromLTRB(
                                details.globalPosition.dx,
                                details.globalPosition.dy - 180, // উপরে শিফট
                                overlay.size.width - details.globalPosition.dx,
                                overlay.size.height -
                                    (details.globalPosition.dy - 180),
                              );

                              final selected =
                                  await showMenu<SignatureMenuAction>(
                                    context: btnCtx,
                                    position: position,
                                    color: Colors.white,
                                    elevation: 12,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.r),
                                    ),
                                    items: [
                                      _buildMenuItem(
                                        icon: CupertinoIcons.camera,
                                        text: 'Camera',
                                        value: SignatureMenuAction.camera,
                                        onTap: () {},
                                      ),
                                      _buildMenuItem(
                                        icon: CupertinoIcons.photo_on_rectangle,
                                        text: 'Import from gallery',
                                        value: SignatureMenuAction.gallery,
                                        onTap: () {},
                                      ),
                                      _buildMenuItem(
                                        icon: CupertinoIcons.pencil,
                                        text: 'Draw',
                                        value: SignatureMenuAction.draw,
                                        onTap: () {
                                          context.push(
                                            NewSignatureScreen.routeName,
                                          );
                                        },
                                      ),
                                    ],
                                  );

                              await _onMenuAction(selected);
                            },
                            child: Icon(
                              CupertinoIcons.add,
                              size: 22.sp,
                              color: const Color(0xFF1C1C1E),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              /// ───────── Saved signatures list (only if _signatures not empty) ─────────
              if (_signatures.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _signatures.length; i++) ...[
                        _SignaturePreviewItem(imagePath: _signatures[i]),
                        if (i != _signatures.length - 1) SizedBox(height: 12.h),
                      ],
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

/// ───────── Popup-menu items (camera / gallery / draw) ─────────
PopupMenuItem<SignatureMenuAction> _buildMenuItem({
  required IconData icon,
  required String text,
  required SignatureMenuAction value,
  required VoidCallback onTap,
}) {
  return PopupMenuItem<SignatureMenuAction>(
    value: value,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
    child: GestureDetector(
      onTap: onTap,
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
    ),
  );
}

/// ───────── single saved-signature row (white card) ─────────
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
