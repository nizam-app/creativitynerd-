import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/features/tools/signature/apply_singturer_screen.dart';

class NewSignatureScreen extends StatefulWidget {
  const NewSignatureScreen({super.key});
  static const String routeName = '/newSignature';

  @override
  State<NewSignatureScreen> createState() => _NewSignatureScreenState();
}

class _NewSignatureScreenState extends State<NewSignatureScreen> {
  final GlobalKey _signatureKey = GlobalKey();
  final List<List<Offset>> _paths = [];

  bool get _hasSignature =>
      _paths.isNotEmpty && _paths.any((p) => p.isNotEmpty);

  void _startStroke(Offset pos) {
    setState(() {
      _paths.add([pos]);
    });
  }

  void _extendStroke(Offset pos) {
    if (_paths.isEmpty) return;
    setState(() {
      _paths.last.add(pos);
    });
  }

  void _clearSignature() {
    setState(() {
      _paths.clear();
    });
  }

  Future<void> _onDonePressed() async {
    if (!_hasSignature) {
      // কিছু আঁকা না থাকলে কিছু করবে না / চাইলে pop করতে পারো
      return;
    }

    try {
      final boundary =
          _signatureKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List bytes = byteData.buffer.asUint8List();

      if (!mounted) return;

      // 🔥 এখান থেকেই apply screen এ push করো
      context.push(
        ApplySignatureScreen.routeName,
        extra: ApplySignatureArgs(
          documentImagePath: 'assets/images/pdfsaveImages.png',
          signatureBytes: bytes,
        ),
      );
    } catch (e) {
      // ইচ্ছা করলে এখানেও error handle করতে পারো
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf4f8fd),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Container(
              height: 44.h,
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pop<Uint8List?>(null),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'New Sign',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF262626),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onDonePressed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF657DF2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // const Divider(height: 0),

            // Drawing area
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) =>
                        _startStroke(details.localPosition),
                    onPanUpdate: (details) =>
                        _extendStroke(details.localPosition),
                    child: RepaintBoundary(
                      key: _signatureKey,
                      child: CustomPaint(
                        painter: _SignaturePainter(_paths),
                        child: Container(),
                      ),
                    ),
                  ),

                  if (!_hasSignature)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 80.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 297.w,
                              height: 1,
                              color: Color(0xFFd6dade),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Sign your name using your finger',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (_hasSignature)
                    Positioned(
                      left: 24.w,
                      bottom: 32.h,
                      child: InkWell(
                        onTap: _clearSignature,
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFededed),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            CupertinoIcons.delete,
                            size: 20,
                            color: Color(0xFFFF3B30),
                          ),
                        ),
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

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> paths;

  _SignaturePainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in paths) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
