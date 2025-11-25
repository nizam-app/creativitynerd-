import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<String> _signatures = [];

  Future<void> _onMenuAction(SignatureMenuAction? action) async {
    if (action == null) return;

    switch (action) {
      case SignatureMenuAction.camera:
        // TODO: Camera logic
        break;
      case SignatureMenuAction.gallery:
        // TODO: Gallery logic
        break;
      case SignatureMenuAction.draw:
        if (!mounted) return;
        context.push(NewSignatureScreen.routeName);
        break;
    }

    // demo data
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
            color: const Color(0xFFf3f7fc),
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

                      /// ➕ আইকনে ক্লিক করলে Figma মতো popup card
                      Builder(
                        builder: (btnCtx) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (details) async {
                              final overlay =
                                  Overlay.of(btnCtx).context.findRenderObject()
                                      as RenderBox;

                              // card টা একটু উপরে show করার জন্য
                              final cardWidth = 222.w;
                              final top = details.globalPosition.dy - 190;
                              double left =
                                  details.globalPosition.dx - cardWidth / 2;
                              // screen bound এর ভেতরে clamp
                              left = left.clamp(
                                8.0,
                                overlay.size.width - cardWidth - 8.0,
                              );

                              final position = RelativeRect.fromLTRB(
                                left,
                                top,
                                overlay.size.width - left - cardWidth,
                                overlay.size.height - top,
                              );

                              final selected =
                                  await showMenu<SignatureMenuAction>(
                                    context: btnCtx,
                                    position: position,
                                    color: Colors
                                        .transparent, // outer color transparent
                                    elevation: 0,
                                    items: [
                                      PopupMenuItem<SignatureMenuAction>(
                                        enabled: false,
                                        padding: EdgeInsets.zero,
                                        child: _SignatureMenuCard(
                                          onSelect: (action) {
                                            Navigator.pop(
                                              btnCtx,
                                              action,
                                            ); // value return
                                          },
                                        ),
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

              /// ───────── Saved signatures list ─────────
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

/// ───────── Figma-style popup card ─────────
class _SignatureMenuCard extends StatelessWidget {
  final ValueChanged<SignatureMenuAction> onSelect;

  const _SignatureMenuCard({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 222.w,
      decoration: BoxDecoration(
        // color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFe3e2e0), Color(0xFFfbfbfb)],
          stops: [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SignatureMenuRow(
            icon: "assets/images/tool/Camera_icon.svg",
            text: 'Camera',
            onTap: () => onSelect(SignatureMenuAction.camera),
          ),
          _SignatureMenuRow(
            icon: "assets/images/tool/Import1.svg",
            text: 'Import from gallery',
            onTap: () => onSelect(SignatureMenuAction.gallery),
          ),
          _SignatureMenuRow(
            icon: "assets/images/tool/Draw.svg",
            text: 'Draw',
            onTap: () => onSelect(SignatureMenuAction.draw),
          ),
        ],
      ),
    );
  }
}

class _SignatureMenuRow extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const _SignatureMenuRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            SvgPicture.asset(icon, color: Colors.grey),

            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
