import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_save_screen.dart';

const Color _kPrimaryBlue = Color(0xFF657DF2);

class ApplySignatureArgs {
  final String documentImagePath;
  final Uint8List? signatureBytes;

  const ApplySignatureArgs({
    required this.documentImagePath,
    this.signatureBytes,
  });
}

class ApplySignatureScreen extends StatefulWidget {
  static const routeName = '/applySignature';

  final String documentImagePath;
  final Uint8List? signatureBytes;

  const ApplySignatureScreen({
    super.key,
    required this.signatureBytes,
    this.documentImagePath = 'assets/images/pdfsaveImages.png',
  });

  @override
  State<ApplySignatureScreen> createState() => _ApplySignatureScreenState();
}

class _ApplySignatureScreenState extends State<ApplySignatureScreen> {
  /// ei key diye sudhu doc + signature (border ছাড়া) capture korbo
  final GlobalKey _docKey = GlobalKey();

  /// signature position & size (document er width/height er ratio)
  double _sigLeftRatio = 0.10;
  double _sigTopRatio = 0.55;
  double _sigWidthRatio = 0.70;
  double _sigHeightRatio = 0.26;
  bool _showSignature = true;

  void _clampPosition() {
    final maxLeft = 1 - _sigWidthRatio;
    final maxTop = 1 - _sigHeightRatio;
    _sigLeftRatio = _sigLeftRatio.clamp(0.0, maxLeft);
    _sigTopRatio = _sigTopRatio.clamp(0.0, maxTop);
  }

  void _clampSize() {
    _sigWidthRatio = _sigWidthRatio.clamp(0.25, 0.95);
    _sigHeightRatio = _sigHeightRatio.clamp(0.10, 0.60);
    _clampPosition();
  }

  Future<void> _onSavePressed() async {
    try {
      final boundary =
          _docKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List bytes = byteData.buffer.asUint8List();

      if (!mounted) return;

      // 👉 direct CropSaveScreen e jao, signed image niye
      context.push(
        CropSaveScreen.routeName,
        extra: bytes, // GoRoute theke Uint8List? hishabe pabe
      );
    } catch (e) {
      // optional: debug print
      // debugPrint('Error on save: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Top bar ----------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Scan 27-sep-2025 at 8:15…',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _onSavePressed,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF657DF2),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- Document + signature canvas ----------
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final docW = constraints.maxWidth;
                      final docH = constraints.maxHeight;

                      final sigW = docW * _sigWidthRatio;
                      final sigH = docH * _sigHeightRatio;
                      final sigLeft = docW * _sigLeftRatio;
                      final sigTop = docH * _sigTopRatio;

                      return Stack(
                        children: [
                          /// 🔹 Ei RepaintBoundary’r vitore sudhu
                          /// document + signature image thakbe (border ছাড়া)
                          RepaintBoundary(
                            key: _docKey,
                            child: Stack(
                              children: [
                                // document
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.asset(
                                      widget.documentImagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // signature image (no border / no handle)
                                if (_showSignature &&
                                    widget.signatureBytes != null)
                                  Positioned(
                                    left: sigLeft,
                                    top: sigTop,
                                    width: sigW,
                                    height: sigH,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.memory(
                                        widget.signatureBytes!,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          /// 🔹 Overlay: border + delete + resize
                          /// Ei part save e dhorbe na (RepaintBoundary’r baire)
                          if (_showSignature && widget.signatureBytes != null)
                            Positioned(
                              left: sigLeft,
                              top: sigTop,
                              width: sigW,
                              height: sigH,
                              child: _SignatureSelectionOverlay(
                                onMove: (delta) {
                                  setState(() {
                                    _sigLeftRatio += delta.dx / docW;
                                    _sigTopRatio += delta.dy / docH;
                                    _clampPosition();
                                  });
                                },
                                onResize: (delta) {
                                  setState(() {
                                    _sigWidthRatio += delta.dx / docW;
                                    _sigHeightRatio += delta.dy / docH;
                                    _clampSize();
                                  });
                                },
                                onDelete: () {
                                  setState(() => _showSignature = false);
                                },
                              ),
                            ),
                        ],
                      );
                    },
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

/// 🔹 Selection overlay: pura box drag, corner theke resize, corner bubble diye delete
class _SignatureSelectionOverlay extends StatelessWidget {
  final void Function(Offset delta) onMove;
  final void Function(Offset delta) onResize;
  final VoidCallback onDelete;

  const _SignatureSelectionOverlay({
    required this.onMove,
    required this.onResize,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // full box drag
      onPanUpdate: (details) {
        onMove(details.delta);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // blue border only
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: _kPrimaryBlue, width: 1.5),
            ),
          ),

          // top-left delete bubble
          Positioned(
            top: -14,
            left: -14,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 17,
                  color: Color(0xFFff4c4c),
                ),
              ),
            ),
          ),

          // bottom-right resize handle
          Positioned(
            right: -10,
            bottom: -10,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                onResize(details.delta);
              },
              child: Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: SvgPicture.asset("assets/images/tool/Group.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
