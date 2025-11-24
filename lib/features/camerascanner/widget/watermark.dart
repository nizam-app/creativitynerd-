import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class WatermarkScreen extends StatefulWidget {
  const WatermarkScreen({super.key});
  static const routeName = "/watermark";

  @override
  State<WatermarkScreen> createState() => _WatermarkScreenState();
}

class _WatermarkScreenState extends State<WatermarkScreen> {
  String watermarkText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ---------- DEMO TOOLBAR ----------
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Watermark",
          style: TextStyle(
            fontFamily: "sf_Pro",
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          // demo background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/camera_image.png",
              fit: BoxFit.cover,
            ),
          ),

          // ✅ watermark overlay preview
          if (watermarkText.isNotEmpty)
            Center(
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  watermarkText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "sf_Pro",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),

      // ---------- DEMO BOTTOM TOOLBAR ----------
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomToolButton(
                svgPath: "assets/images/watermark.svg",
                label: "Watermark",
                onTap: () async {
                  final text = await showWatermarkBottomSheet(
                    context,
                    initialText: watermarkText,
                    initialFontSize: 12,
                  );

                  if (text != null) {
                    setState(() => watermarkText = text);
                  }
                },
              ),
              BottomToolButton(
                svgPath: "assets/images/export_icon.svg",
                label: "Export",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==================================
/// ✅ Bottom toolbar button (example)
/// ==================================
class BottomToolButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const BottomToolButton({
    super.key,
    required this.svgPath,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF0A84FF) : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24.sp,
              height: 24.sp,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================
/// ✅ SHOW BOTTOMSHEET FUNCTION
/// ============================
Future<String?> showWatermarkBottomSheet(
    BuildContext context, {
      String initialText = "",
      double initialFontSize = 12,
    }) async {
  final controller = TextEditingController(text: initialText);

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (_) {
      return Watermark(
        controller: controller,
        initialFontSize: initialFontSize,
        onCancel: () => Navigator.pop(context),
        onDone: () => Navigator.pop(context, controller.text.trim()),
      );
    },
  );

  controller.dispose();
  return result;
}

/// ============================
/// ✅ WATERMARK BOTTOMSHEET UI
/// ============================
class Watermark extends StatefulWidget {
  const Watermark({
    super.key,
    required this.controller,
    this.onDone,
    this.onCancel,
    this.initialFontSize = 12,
  });

  final TextEditingController controller;
  final VoidCallback? onDone;
  final VoidCallback? onCancel;
  final double initialFontSize;

  @override
  State<Watermark> createState() => _WatermarkState();
}

class _WatermarkState extends State<Watermark> {
  late double _fontSize;
  String _fontName = "SF Pro";
  TextAlign _align = TextAlign.left;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.initialFontSize;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        ),
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          top: 8.h,
          bottom: 10.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ===== Top Bar =====
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onCancel?.call();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: "sf_Pro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3C3C43),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "Add text",
                  style: TextStyle(
                    fontFamily: "sf_Pro",
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.onDone?.call();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontFamily: "sf_Pro",
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0A84FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // ===== Toolbar Row =====
            Row(
              children: [
                _pillButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _align == TextAlign.left
                            ? Icons.format_align_left
                            : _align == TextAlign.center
                            ? Icons.format_align_center
                            : Icons.format_align_right,
                        size: 18.sp,
                        color: Colors.black,
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.keyboard_arrow_down,
                          size: 18.sp, color: const Color(0xFF0A84FF)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (_align == TextAlign.left) {
                        _align = TextAlign.center;
                      } else if (_align == TextAlign.center) {
                        _align = TextAlign.right;
                      } else {
                        _align = TextAlign.left;
                      }
                    });
                  },
                ),

                SizedBox(width: 8.w),
                _pillButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _fontSize = (_fontSize - 1).clamp(8, 72);
                          });
                        },
                        child: Icon(Icons.remove,
                            size: 18.sp, color: const Color(0xFF0A84FF)),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${_fontSize.toInt()} pt",
                        style: TextStyle(
                          fontFamily: "sf_Pro",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _fontSize = (_fontSize + 1).clamp(8, 72);
                          });
                        },
                        child: Icon(Icons.add,
                            size: 18.sp, color: const Color(0xFF0A84FF)),
                      ),
                    ],
                  ), onTap: () { },
                ),

                SizedBox(width: 8.w),
                _pillButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _fontName,
                        style: TextStyle(
                          fontFamily: "sf_Pro",
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.keyboard_arrow_down,
                          size: 18.sp, color: const Color(0xFF0A84FF)),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _fontName = _fontName == "SF Pro" ? "Poppins" : "SF Pro";
                    });
                  },
                ),

                const Spacer(),

                InkWell(
                  onTap: () => Navigator.pop(context),
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 34.w,
                    height: 34.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // ===== Text Field Area =====
            Container(
              width: double.infinity,
              height: 170.h,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFFE5E5EA),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                maxLines: null,
                textAlign: _align,
                style: TextStyle(
                  fontFamily: "sf_Pro",
                  fontSize: _fontSize.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: "Type here",
                  hintStyle: TextStyle(
                    fontFamily: "sf_Pro",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0x993C3C43), // 60% opacity
                  ),
                ),
              ),
            ),

            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _pillButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}
