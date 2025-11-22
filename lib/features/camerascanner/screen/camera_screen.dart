import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/edit_filter_screen.dart';
import 'package:pdf_scanner/features/onbording/widget/CustomButton.dart';

import '../widget/customBarcodeDialog.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  static const String routeName = '/cameraScanner';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _selectedMode = 0; // 0 = DOCUMENT, 1 = QR CODE, 2 = ID CARD, ...
  final List<String> _modes = const [
    'DOCUMENT',
    'QR CODE',
    'ID CARD',
    'BOOK',
    'ID PHOTO',
    'OCR',
  ];

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isCameraReady = false;

  // DOCUMENT: page-mode design state
  bool _isMultiPage = false;
  int _pageCount = 1; // 1 for single, 5 for multi (design only)

  // QR: QR / Bar toggle state
  bool _qrSelected = true;

  // ==== ID CARD STATE ====
  int _idStep = 0;         // 0/1 = A4 examples, 2 = camera view
  bool _idBothSides = false;

  // --------- helpers ---------
  String get _backgroundImage {
    switch (_selectedMode) {
      case 1: // QR CODE
        return 'assets/images/qrCode.png';
      case 2: // ID CARD
        return 'assets/images/id_card.png';
      case 3:
        return 'assets/images/book.png';
      case 4:
        return 'assets/images/id_photo.png';
      default: // DOCUMENT + others
        return 'assets/images/camera_image.png';
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _showResolutionPopup(BuildContext context) {
    showMenu(
      color: AllColor.gery100.withOpacity(0.60),
      context: context,
      position: const RelativeRect.fromLTRB(100, 105, 100, 100),
      elevation: 8.0,
      items: [
        PopupMenuItem<String>(
          value: '12M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: AllColor.white),
                  SizedBox(width: 8.w),
                  const Text("12M (3968x2976)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '8M',
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  const Text("8M (3840x2160)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '5M',
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  const Text("5M (3072x1728)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '4M',
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  const Text("4M (2560x1920)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2M',
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  const Text("2M (1920x1088)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2)),
            ],
          ),
        ),
      ],
    );
  }

  void _onModeTap(int index) {
    setState(() {
      _selectedMode = index;

      // Reset per-mode state
      if (index == 0) {
        // DOCUMENT
        _isMultiPage = false;
        _pageCount = 1;
      } else if (index == 1) {
        // QR CODE
        _qrSelected = true;
      } else if (index == 2) {
        // ==== ID CARD ====
        _idStep = 0;
        _idBothSides = false;
      }
    });
  }

  void _showCustomPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 105, 10, 200),
      color: AllColor.gery100.withOpacity(0.60),
      elevation: 8.0,
      items: [
        PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/charge.svg', width: 24.w, height: 24.w),
              SizedBox(width: 20.w),
              SvgPicture.asset('assets/images/charge_x.svg', width: 24.w, height: 24.w),
              SizedBox(width: 20.w),
              SvgPicture.asset('assets/images/charge_a.svg', width: 24.w, height: 24.w),
              SizedBox(width: 20.w),
              SvgPicture.asset('assets/images/charge_light.svg', width: 24.w, height: 24.w),
            ],
          ),
        ),
      ],
    );
  }

  // --------- UI ---------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.black,
      body: SafeArea(
        child: Column(
          children: [
            // ========= TOP BAR =========
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AllColor.white, size: 22.sp),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.push(CropScreen.routeName),
                    iconSize: 22.sp,
                    icon: SvgPicture.asset(
                      'assets/images/crop.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showResolutionPopup(context),
                    iconSize: 22.sp,
                    icon: SvgPicture.asset(
                      'assets/images/hq.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showCustomPopupMenu(context),
                    iconSize: 22.sp,
                    icon: SvgPicture.asset(
                      'assets/images/charge.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),

            // ========= CAMERA AREA + OVERLAYS =========
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // camera background (design only)
                    ClipRRect(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.asset(
                          _backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // ---- QR MODE overlay ----
                    if (_selectedMode == 1) const _QrScannerOverlay(),

                    // ---- DOCUMENT Single/Multi pill ----
                    if (_selectedMode == 0)
                      Positioned(
                        bottom: 40.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AllColor.gery100,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              _buildPageModeChip(
                                'Single page',
                                selected: !_isMultiPage,
                                onTap: () {
                                  setState(() {
                                    _isMultiPage = false;
                                    _pageCount = 1;
                                  });
                                },
                              ),
                              SizedBox(width: 4.w),
                              _buildPageModeChip(
                                'Multi page',
                                selected: _isMultiPage,
                                onTap: () {
                                  setState(() {
                                    _isMultiPage = true;
                                    _pageCount = 5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ---- QR Code / Bar Code pill ----
                    // if (_selectedMode == 1)
                    //   Positioned(
                    //     bottom: 40.h,
                    //     child: _QrBarcodeToggle(
                    //       qrSelected: _qrSelected,
                    //       onChanged: (isQr) {
                    //         setState(() => _qrSelected = isQr);
                    //
                    //         // when Bar Code selected -> show popup
                    //         if (!isQr) {
                    //           CustomBarcodeDialog.show(context);
                    //         }
                    //       },
                    //     ),
                    //   ),

                    if (_selectedMode == 1)
                      Positioned(
                        bottom: 40.h,
                        child: _QrBarcodeToggle(
                          qrSelected: _qrSelected,
                          onChanged: (isQr) {
                            setState(() => _qrSelected = isQr);

                            // when Bar Code selected -> show popup
                            if (!isQr) {
                              CustomBarcodeDialog.show(context);
                            }
                          },
                        ),
                      ),

                    // ==== ID CARD OVERLAY (steps) ====
                    if (_selectedMode == 2 && _idStep < 2)
                      _IdA4Panel(
                        bothSides: _idBothSides,
                        onToggle: (both) {
                          setState(() {
                            _idBothSides = both;
                            _idStep = both ? 1 : 0;
                          });
                        },
                      ),

                    if (_selectedMode == 2 && _idStep == 2)
                      _IdCameraOverlay(
                        bothSides: _idBothSides,
                      ),

                    // ---- bottom DOCUMENT / QR / ID / ... tabs (same for all) ----
                    Positioned(
                      bottom: 0.h,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          _modes.length,
                              (index) => _ModeTab(
                            label: _modes[index],
                            selected: _selectedMode == index,
                            onTap: () => _onModeTap(index),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ========= BOTTOM CONTROLS =========
            if (!(_selectedMode == 2 && _idStep < 2))
            // normal camera bottom (DOCUMENT, QR, ID camera step)
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 16.h,
                  bottom: 24.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // For ID camera step show One side / Both sides pill above button
                    if (_selectedMode == 2 && _idStep == 2)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _SideToggle(
                          bothSides: _idBothSides,
                          onChanged: (both) {
                            setState(() {
                              _idBothSides = both;
                            });
                          },
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Gallery button
                        InkWell(
                          onTap: () => context.push(EditFilterScreen.routeName),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/add_photo.svg',
                              height: 48.h,
                              width: 48.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // Capture button
                        GestureDetector(
                          onTap: () {
                            // TODO: capture / scan
                          },
                          child: Container(
                            width: 76.w,
                            height: 76.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4.w),
                            ),
                            child: Center(
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Preview with badge
                        ImageWithBadge(
                          imagePath: _backgroundImage,
                          count: _selectedMode == 0 ? _pageCount : 1,
                          isMultiPage: _selectedMode == 0 && _isMultiPage,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
            // ID CARD Step 0/1 bottom: "Make it now" button

            Container(
              padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 15.h, bottom: 15.h),
              height: 90.h,
              decoration: BoxDecoration(
                color: AllColor.white
              ),
              child: SizedBox(
                height: 48.h,
                child: CustomButton(
                    text: "Make it now",
                    textColor: AllColor.white,
                    fontSize: 17.h,
                    fontWeight: FontWeight.w600,
                    backgroundColor: AllColor.primary,
                    onPressed: (){
                      setState(() {
                        _idStep = 2;
                      });
                    }),
              ),


            ),


          ],
        ),
      ),
    );
  }

  // ---------- helpers ----------
  Widget _buildPageModeChip(
      String text, {
        required bool selected,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AllColor.primary : AllColor.gery100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'sf_Pro',
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AllColor.white,
          ),
        ),
      ),
    );
  }
}

// ========== Shared small widgets / custom classes ==========

class _ModeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'sf_Pro',
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: selected ? AllColor.primary : Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: selected ? Colors.white : AllColor.black,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small preview image with badge.
class ImageWithBadge extends StatelessWidget {
  final String imagePath;
  final int count;
  final bool isMultiPage;

  const ImageWithBadge({
    Key? key,
    required this.imagePath,
    required this.count,
    required this.isMultiPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 55.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11.r),
            child: Image.asset(
              imagePath,
              width: 44.w,
              height: 55.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: isMultiPage ? 40.h : 15.h,
            left: isMultiPage ? -6.w : -10.w,
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AllColor.red,
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AllColor.white,
                    fontFamily: "sf_Pro",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark QR overlay with transparent rounded square + blue border
class _QrScannerOverlay extends StatelessWidget {
  const _QrScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrOverlayPainter(),
      size: Size.infinite,
    );
  }
}

class _QrOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;

    // dark overlay
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.45);
    canvas.drawRect(fullRect, overlayPaint);

    // scan area
    final double boxSize = size.width * 0.55;
    final Rect scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: boxSize,
      height: boxSize,
    );
    final rrect = RRect.fromRectAndRadius(scanRect, const Radius.circular(20));

    final holePath = Path()
      ..addRect(fullRect)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      holePath,
      Paint()..color = Colors.black.withOpacity(0.55),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF4B7BFF);

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// QR Code / Bar Code switch pill for QR mode
class _QrBarcodeToggle extends StatelessWidget {
  final bool qrSelected; // true = QR, false = Bar
  final ValueChanged<bool> onChanged;

  const _QrBarcodeToggle({
    required this.qrSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(width: 1.w, color: AllColor.qrColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SmallToggleChip(
            label: 'QR Code',
            selected: qrSelected,
            onTap: () => onChanged(true),
          ),
          SizedBox(width: 4.w),
          _SmallToggleChip(
            label: 'Bar Code',
            selected: !qrSelected,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _SmallToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SmallToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AllColor.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            fontFamily: "sf_Pro",
            color: selected ? Colors.white : Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

/// ====== ID CARD SPECIFIC WIDGETS ======


class _IdA4Panel extends StatelessWidget {
  final bool bothSides;
  final ValueChanged<bool> onToggle;

  const _IdA4Panel({
    required this.bothSides,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 260.w,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   'A4 paper example',
                //   style: TextStyle(
                //     fontSize: 16.sp,
                //     fontWeight: FontWeight.w700,
                //     fontFamily: "sf_Pro",
                //     color: AllColor.black,
                //   ),
                // ),
                // SizedBox(height: 16.h),
                   Image.asset(
                     bothSides
                         ? 'assets/images/one_side.png'
                         : 'assets/images/both_site.png',
                     fit: BoxFit.cover,
                   ),

                SizedBox(height: 16.h),

              ],
            ),
          ),
           const Spacer(),
          _SideToggle(
            bothSides: bothSides,
            onChanged: onToggle,
          ),
           const Spacer(),
        ],
      ),
    );
  }
}

/// ID camera overlay (step 2)
class _IdCameraOverlay extends StatelessWidget {
  final bool bothSides;

  const _IdCameraOverlay({required this.bothSides});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Text(
          bothSides ? 'Front' : 'Front',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "sf_Pro",
            color: AllColor.white,
          ),
        ),
         Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal:20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: AllColor.black.withOpacity(0.4),
            //     blurRadius: 16,
            //     offset:  Offset(0, 6),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              'assets/images/id_card.png', // change to your asset
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

/// Toggle: One side / Both sides (used in A4 & camera bottom)
class _SideToggle extends StatelessWidget {
  final bool bothSides;
  final ValueChanged<bool> onChanged;

  const _SideToggle({
    required this.bothSides,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        // color:AllColor.borderColor.withOpacity(0.55),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(width: 1.w, color: AllColor.borderColor.withOpacity(0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SideChip(
            label: 'One side',
            selected: !bothSides,
            onTap: () => onChanged(false),
          ),
          SizedBox(width: 4.w),
          _SideChip(
            label: 'Both sides',
            selected: bothSides,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _SideChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SideChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? AllColor.primary : Colors.transparent,
           borderRadius: BorderRadius.circular(14.r),

        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            fontFamily: "sf_Pro",
            color: selected ? Colors.white : Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
