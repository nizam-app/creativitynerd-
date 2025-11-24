import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:go_router/go_router.dart";
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/tools/screen/Congratulations_screen.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/data/ducment_selecd_data.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/marge_pdf_45.dart';

class PageOrganizeScreen extends ConsumerStatefulWidget {
  const PageOrganizeScreen({super.key});
  static const String routeName = '/pageOrganize';

  @override
  ConsumerState<PageOrganizeScreen> createState() => _PageOrganizeScreenState();
}

class _PageOrganizeScreenState extends ConsumerState<PageOrganizeScreen> {
  /// demo page count – পরে তুমি API/real data থেকে সেট করতে পারবে
  int _totalPages = 3;
  int _currentPage = 0;

  void _onSelect(int index) {
    if (index >= _totalPages) return; // last card = Add new page
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod: selected indexes
    final selectedIndexes = ref.watch(documentSelectionProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan 27-sep-2025 at 8:15',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              showExportBottomSheet(context);
            },
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF657DF2),
              ),
            ),
          ),
        ],
      ),

      // ───────── BODY ─────────
      body: Column(
        children: [
          // ───────── GRID: pages + add new page ─────────
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 180.w / 240.h, // image-1 ratio এর কাছাকাছি
              ),
              itemCount: _totalPages + 1, // last = Add new page
              itemBuilder: (context, index) {
                // last tile = Add new page
                if (index == _totalPages) {
                  return _AddNewPageTile(
                    onTap: () {
                      // এখানে নতুন পেজ add করার logic বসাও
                    },
                  );
                }

                final pageNo = (index + 1).toString().padLeft(2, '0');
                final selected = selectedIndexes.contains(index);

                return PageThumbCard(
                  thumbnail: Image.asset(
                    'assets/images/tool/maiye.png',
                    fit: BoxFit.cover,
                  ),
                  pageNumber: pageNo,
                  isSelected: selected,
                  onTap: () {
                    _onSelect(index);
                    ref.read(documentSelectionProvider.notifier).toggle(index);
                  },
                  onMoreTap: () {
                    // 3-dot menu action
                  },
                );
              },
            ),
          ),

          // ───────── Bottom control area ─────────
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // page indicator ( < 1/25 > )
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.back,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${_currentPage + 1}/$_totalPages',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Transform.rotate(
                          angle: math.pi,
                          child: Icon(
                            CupertinoIcons.back,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _BottomAction(
                        imagePath: "assets/images/edit_icon.svg",
                        label: 'Edit page',
                      ),
                      _BottomAction(
                        imagePath: "assets/images/retake_icon.svg",
                        label: 'Retake',
                      ),
                      _BottomAction(
                        imagePath: "assets/images/rotate_icon.svg",
                        label: 'Rotate',
                      ),
                      _BottomAction(
                        imagePath: "assets/images/tool/file-add.svg",
                        label: 'Add page',
                      ),
                      _BottomAction(
                        imagePath: "assets/images/tool/delete.svg",
                        label: 'Delete',
                      ),
                      _BottomAction(
                        imagePath: "assets/images/tool/download.svg",
                        label: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────── Add new page tile (grey card) ─────────
class _AddNewPageTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddNewPageTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              SvgPicture.asset("assets/images/tool/camera-add-02.svg"),
              Spacer(),

              Text(
                'Add new page',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 25.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// ───────── bottom toolbar button ─────────
class _BottomAction extends StatelessWidget {
  final String imagePath;
  final String label;

  const _BottomAction({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(imagePath, width: 24.w, height: 24.w),

        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// ───────── Single page tile (image-1 style) ─────────
class PageThumbCard extends StatelessWidget {
  final Widget thumbnail;
  final String pageNumber; // e.g. "01", "02", "03"
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const PageThumbCard({
    super.key,
    required this.thumbnail,
    required this.pageNumber,
    this.isSelected = false,
    this.onTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = 18.r;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Stack(
            children: [
              // full image
              Positioned.fill(child: thumbnail),

              // selected blue border (outer stroke)
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(
                        color: const Color(0xFF068FFF),
                        width: 3,
                      ),
                    ),
                  ),
                ),

              // bottom gradient + page number + more icon
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(borderRadius),
                  ),
                  child: BackdropFilter(
                    // ✅ background blur, glass effect
                    filter: ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      height: 44.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      // ✅ halka dark transparent, screenshot er moto
                      color: Colors.black.withOpacity(0.40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // page number (01)
                          Text(
                            pageNumber,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          // 3-dot more icon
                          GestureDetector(
                            onTap: onMoreTap,
                            child: SvgPicture.asset(
                              "assets/images/tool/horizontal-drag-&-drop.svg",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const Color _kPrimaryBlue = Color(0xFF657DF2);

void showExportBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.35),
    builder: (ctx) => const _ExportBottomSheet(),
  );
}

class _ExportBottomSheet extends StatefulWidget {
  const _ExportBottomSheet({super.key});

  @override
  State<_ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<_ExportBottomSheet> {
  bool _exportPdf = true;
  double _quality = 0.5; // 0 = Low, 0.5 = Medium, 1 = HD
  bool _removeWatermark = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return FractionallySizedBox(
      heightFactor: 0.72,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 8.h,
            bottom: media.padding.bottom + 16.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FF), // হালকা bluish, image-1 মত
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── drag handle (sheet er ভেতরে) ──
              Container(
                width: 44.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8CCDD),
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),

              // ── TOP document row + নিচের divider ──
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // thumbnail
                      // 🔹 Replace your old "Icon description" Container with this:
                      Container(
                        width: 48.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF1F3F8,
                          ), // light blue bg (outer)
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(color: const Color(0xFFE0E3EC)),
                        ),
                        child: Center(
                          child: Container(
                            width: 40.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: Colors.white, // inner white card
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                // BoxShadow(
                                //   color: Colors.black.withOpacity(0.06),
                                //   blurRadius: 4,
                                //   offset: const Offset(0, 2),
                                // ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/document.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // file name + dashed underline (full width)
                      Expanded(
                        child: SizedBox(
                          height: 60.h,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              // dashed line পুরো width জুড়ে
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 10.h,
                                child: SizedBox(
                                  height: 10.h,
                                  child: CustomPaint(
                                    painter: _DashedLinePainter(
                                      color: AllColor.black,
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                'PDFScanner10-18-2025',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AllColor.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FittedBox(
                        child: SvgPicture.asset(
                          "assets/images/edit_icon.svg",
                          color: AllColor.black,
                          width: 15.w,
                          height: 15.h,
                        ),
                      ),

                      // edit icon
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // নিচের পাতলা divider (full width)
                  Divider(
                    color: const Color(0xFFE0E3EC),
                    thickness: 1,
                    height: 1,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // ── Export Document as ──
              _SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Export Document as',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1F2430),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3FA), // light gray pill
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Row(
                          children: [
                            _SegmentChip(
                              label: 'PDF',
                              isSelected: _exportPdf,
                              onTap: () {
                                setState(() => _exportPdf = true);
                              },
                            ),
                            _SegmentChip(
                              label: 'Image',
                              isSelected: !_exportPdf,
                              onTap: () {
                                setState(() => _exportPdf = false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // ── Set Quality ──
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Set Quality',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F2430),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.workspace_premium_rounded, // crown এর মত কিছু
                          size: 16.sp,
                          color: Colors.orange.shade400,
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // 🔹 EXACT iOS style slider (image-1 এর মত)
                    SizedBox(
                      height: 36.h,
                      child: Row(
                        children: [
                          _QualityEndDot(), // left circle

                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // full blue line
                                Container(height: 3.h, color: _kPrimaryBlue),

                                // thumb only (track hide করা)
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 0, // track invisible
                                    inactiveTrackColor: Colors.transparent,
                                    activeTrackColor: Colors.transparent,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 11.r,
                                    ),
                                    thumbColor: _kPrimaryBlue,
                                  ),
                                  child: Slider(
                                    value: _quality,
                                    min: 0,
                                    max: 2,
                                    divisions: 2,
                                    onChanged: (v) {
                                      setState(() => _quality = v);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _QualityEndDot(), // right circle
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // নিচের Low / Medium / HD label গুলো
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QualityLabel(
                          label: 'Low',
                          isActive: _quality.round() == 0,
                        ),
                        _QualityLabel(
                          label: 'Medium',
                          isActive: _quality.round() == 1,
                        ),
                        _QualityLabel(
                          label: 'HD',
                          isActive: _quality.round() == 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // ── Remove watermark ──
              _SectionCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Remove watermark',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1F2430),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          SvgPicture.asset(
                            "assets/images/tool/crown.svg",
                            height: 20.h,
                            width: 20.w,
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: _removeWatermark,
                      activeColor: const Color(0xFF34C759),
                      onChanged: (val) {
                        setState(() => _removeWatermark = val);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // ── Save button ──
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  onPressed: () {
                    context.push(
                      CongratulationsScreen.routeName,
                      extra: ScreenName.filter,
                    );
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// dashed underline painter (top file name র নীচের line)
class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 4;
    const double dashSpace = 3;

    double x = 0;
    final double y = size.height / 2;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + dashWidth, y), paint);
      x += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Card-style white section (Export / Quality / Remove watermark)
class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }
}

/// Small chip used for "PDF / Image" segmented control
class _SegmentChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          // parent container already light-gray,
          // selected side = blue pill, unselected = transparent
          decoration: BoxDecoration(
            color: isSelected ? _kPrimaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF000000),
            ),
          ),
        ),
      ),
    );
  }
}

/// Low / Medium / HD text labels
class _QualityLabel extends StatelessWidget {
  final String label;
  final bool isActive;

  const _QualityLabel({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive ? _kPrimaryBlue : const Color(0xFF9BA3B6),
      ),
    );
  }
}

class _QualityEndDot extends StatelessWidget {
  const _QualityEndDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.w,
      height: 22.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: _kPrimaryBlue, width: 2),
      ),
    );
  }
}

// class _QualitySlider extends StatelessWidget {
//   final double value; // 0.0, 0.5, 1.0
//   final ValueChanged<double> onChanged;
//
//   const _QualitySlider({required this.value, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     // snap value to 0, 0.5, 1.0
//     int index;
//     if (value <= 0.25) {
//       index = 0;
//     } else if (value <= 0.75) {
//       index = 1;
//     } else {
//       index = 2;
//     }
//
//     return SizedBox(
//       height: 36.h,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final double w = constraints.maxWidth;
//           final double linePadding = 8.w;
//
//           final double startX = linePadding;
//           final double endX = w - linePadding;
//           final double midX = (startX + endX) / 2;
//
//           final positions = [startX, midX, endX];
//           final double thumbX = positions[index];
//
//           return Stack(
//             alignment: Alignment.center,
//             children: [
//               // full blue line
//               Positioned(
//                 left: startX,
//                 right: linePadding,
//                 child: Container(height: 3.h, color: _kPrimaryBlue),
//               ),
//
//               // left hollow dot
//               Positioned(left: startX - 10, child: _endDot()),
//
//               // right hollow dot
//               Positioned(left: endX - 10, child: _endDot()),
//
//               // moving thumb (filled circle)
//               Positioned(
//                 left: thumbX - 12,
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {}, // just to increase tap area
//                   onHorizontalDragEnd: (_) {},
//                   onTapUp: (_) {},
//                   child: Container(
//                     width: 24,
//                     height: 24,
//                     decoration: const BoxDecoration(
//                       color: _kPrimaryBlue,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ),
//
//               // invisible Slider only for gesture (snaps to 3 steps)
//               SliderTheme(
//                 data: SliderTheme.of(context).copyWith(
//                   trackHeight: 0,
//                   activeTrackColor: Colors.transparent,
//                   inactiveTrackColor: Colors.transparent,
//                   thumbShape: const RoundSliderThumbShape(
//                     enabledThumbRadius: 0.0,
//                   ),
//                   overlayShape: SliderComponentShape.noOverlay,
//                 ),
//                 child: Slider(
//                   value: value,
//                   min: 0,
//                   max: 1,
//                   onChanged: (v) {
//                     double snap;
//                     if (v <= 0.33) {
//                       snap = 0.0;
//                     } else if (v <= 0.66) {
//                       snap = 0.5;
//                     } else {
//                       snap = 1.0;
//                     }
//                     onChanged(snap);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _endDot() {
//     return Container(
//       width: 20,
//       height: 20,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//         border: Border.all(color: _kPrimaryBlue, width: 2),
//       ),
//     );
//   }
// }
