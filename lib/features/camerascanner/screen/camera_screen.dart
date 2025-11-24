import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/edit_filter_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/photo_scan.dart';
import 'package:pdf_scanner/features/onbording/widget/CustomButton.dart';
import 'package:pdf_scanner/features/tools/screen/auto_crop_screen.dart';

import '../widget/customBarcodeDialog.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  static const String routeName = '/cameraScanner';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // ---- MODES ----
  static const int _modeDocument = 0;
  static const int _modeQr = 1;
  static const int _modeIdCard = 2;
  static const int _modeBook = 3;
  static const int _modeIdPhoto = 4;
  static const int _modeOcr = 5;

  int _selectedMode = _modeDocument;

  final List<String> _modes = const [
    'DOCUMENT',
    'QR CODE',
    'ID CARD',
    'BOOK',
    'ID PHOTO',
    'OCR EXTRECT',
  ];

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isCameraReady = false;

  // DOCUMENT
  bool _isMultiPage = false;
  int _pageCount = 1;

  // QR
  bool _qrSelected = true;

  // ID CARD
  /// 0 = A4 one side, 1 = A4 both sides, 2 = Front capture
  int _idStep = 0;
  bool _idBothSides = false;

  // BOOK
  bool _bookSplitLine = false; // false = no dashed line, true = dashed line

  // ID PHOTO
  /// 0 = example + Capture button, 1 = camera with face frame
  int _idPhotoStep = 0;

  // --------- helpers ---------
  String get _backgroundImage {
    switch (_selectedMode) {
      case _modeQr:
        return 'assets/images/qrCode.png';
      case _modeIdCard:
        return 'assets/images/camera_image.png';
      case _modeBook:
        return 'assets/images/book.png';
      case _modeIdPhoto:
        return 'assets/images/id_photo.png';
      case _modeOcr:
        return 'assets/images/camera_image.png';
      default:
        return 'assets/images/camera_image.png';
    }
  }

  // ID-card constant assets
  static const String _idA4OneSideImage = 'assets/images/one_side.png';
  static const String _idA4BothSidesImage = 'assets/images/both_site.png';
  static const String _idFrontCardImage = 'assets/images/id_card.png';

  // ID-photo example assets
  static const String _idPhotoBadExample = 'assets/images/id_photo.png';
  static const String _idPhotoGoodExample = 'assets/images/id_photo.png';

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _showResolutionPopup(BuildContext context) {
    showMenu(
      color: AllColor.gery100.withOpacity(0.60),
      context: context,
      position: const RelativeRect.fromLTRB(90, 100, 20, 80),
      elevation: 8.0,
      items: [
        _buildResolutionItem('12M (3968x2976)', true),
        _buildResolutionItem('8M (3840x2160)', false),
        _buildResolutionItem('5M (3072x1728)', false),
        _buildResolutionItem('4M (2560x1920)', false),
        _buildResolutionItem('2M (1920x1088)', false),
      ],
    );
  }

  PopupMenuItem<String> _buildResolutionItem(String label, bool checked) {
    return PopupMenuItem<String>(
      value: label,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check,
                color: checked ? AllColor.white : Colors.transparent,
              ),
              SizedBox(width: 8.w),
              Text(label),
            ],
          ),
          Divider(color: AllColor.gery.withOpacity(0.2)),
        ],
      ),
    );
  }

  void _onModeTap(int index) {
    setState(() {
      _selectedMode = index;

      if (index == _modeDocument) {
        _isMultiPage = false;
        _pageCount = 1;
      } else if (index == _modeQr) {
        _qrSelected = true;
      } else if (index == _modeIdCard) {
        _idStep = 0;
        _idBothSides = false;
      } else if (index == _modeBook) {
        _bookSplitLine = false;
      } else if (index == _modeIdPhoto) {
        _idPhotoStep = 0;
      }
    });
  }

  void _showCustomPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(90, 100, 20, 80),
      color: AllColor.gery100.withOpacity(0.60),
      elevation: 8.0,
      items: [
        PopupMenuItem<String>(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/charge.svg',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 20.w),
              SvgPicture.asset(
                'assets/images/charge_x.svg',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 20.w),
              SvgPicture.asset(
                'assets/images/charge_a.svg',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 20.w),
              SvgPicture.asset(
                'assets/images/charge_light.svg',
                width: 24.w,
                height: 24.w,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showCameraBottom =
        !((_selectedMode == _modeIdCard && _idStep < 2) ||
            (_selectedMode == _modeIdPhoto && _idPhotoStep == 0));

    final bool isIdPhotoMode = _selectedMode == _modeIdPhoto;

    return Scaffold(
      backgroundColor: AllColor.black,

      // appBar: CustomEditAppBar(title: "title", textColor: Colors.white,),
      body: SafeArea(
        child: Column(
          children: [
            // ========= TOP BAR (MATCH SCREENSHOT MARGIN) =========
            Container(
              //height: 56.h,
              padding: EdgeInsets.only(
                left: 6.w,
                right: 6.w,
                top: 6.h,
                bottom: 4.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.w,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AllColor.white, size: 22.sp),
                  ),
                  const Spacer(),

                  // ID-PHOTO => photo_scan.svg, others => crop.svg
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.w,
                    ),
                    onPressed: () {
                      if (isIdPhotoMode) {
                        context.push(PhotoScan.routeName);
                      } else {
                        context.push(CropScreen.routeName);
                      }
                    },
                    iconSize: 24.sp,
                    icon: SvgPicture.asset(
                      isIdPhotoMode
                          ? 'assets/images/photo_scan.svg'
                          : 'assets/images/crop.svg',
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.w,
                    ),
                    onPressed: () => _showResolutionPopup(context),
                    iconSize: 24.sp,
                    icon: SvgPicture.asset(
                      'assets/images/hq.svg',
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  SizedBox(width: 6.w),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.w,
                    ),
                    onPressed: () => _showCustomPopupMenu(context),
                    iconSize: 24.sp,
                    icon: SvgPicture.asset(
                      'assets/images/charge.svg',
                      width: 24.w,
                      height: 24.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
                  alignment: Alignment.topCenter,
                  children: [
                    ClipRRect(
                      child: AspectRatio(
                        aspectRatio: 3 / 4.6,
                        child: Opacity(
                          opacity: _selectedMode == _modeIdCard ? 0.5 : 1.0,
                          child: Image.asset(
                            _backgroundImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedMode == _modeQr) const _QrScannerOverlay(),
                    if (_selectedMode == _modeDocument)
                      Positioned(
                        bottom: 60.h,
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

                    if (_selectedMode == _modeQr)
                      Positioned(
                        bottom: 64.h,
                        child: SafeArea(
                          top: false,
                          child: _QrBarcodeToggle(
                            qrSelected: _qrSelected,
                            onChanged: (isQr) {
                              setState(() => _qrSelected = isQr);
                              if (!isQr) {
                                CustomBarcodeDialog.show(context);
                              }
                            },
                          ),
                        ),
                      ),

                    if (_selectedMode == _modeIdCard && _idStep < 2)
                      Padding(
                        padding: EdgeInsets.only(bottom: 120.h),
                        child: _IdA4Panel(
                          bothSides: _idBothSides,
                          oneSideImage: _idA4OneSideImage,
                          bothSideImage: _idA4BothSidesImage,
                        ),
                      ),

                    if (_selectedMode == _modeIdCard && _idStep == 2)
                      _IdCameraOverlay(
                        bothSides: _idBothSides,
                        cardImage: _idFrontCardImage,
                      ),

                    if (_selectedMode == _modeBook)
                      _BookOverlay(showSplitLine: _bookSplitLine),

                    if (_selectedMode == _modeIdPhoto && _idPhotoStep == 0)
                      _IdPhotoExamplePanel(
                        badExample: _idPhotoBadExample,
                        goodExample: _idPhotoGoodExample,
                      ),

                    if (_selectedMode == _modeIdPhoto && _idPhotoStep == 1)
                      const _IdPhotoCameraOverlay(),

                    if (_selectedMode == _modeIdCard)
                      Positioned(
                        bottom: 64.h,
                        child: SafeArea(
                          top: false,
                          child: _SideToggle(
                            bothSides: _idBothSides,
                            onChanged: (both) {
                              setState(() {
                                _idBothSides = both;
                                if (_idStep < 2) {
                                  _idStep = both ? 1 : 0;
                                }
                              });
                            },
                          ),
                        ),
                      ),

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
            if (showCameraBottom)
              Padding(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 10.h,
                  bottom: 22.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => context.push(EditFilterScreen.routeName),
                      child: SvgPicture.asset(
                        'assets/images/add_photo.svg',
                        height: 48.h,
                        width: 48.w,
                        fit: BoxFit.contain,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        if (_selectedMode == _modeBook &&
                            _bookSplitLine == false) {
                          setState(() => _bookSplitLine = true);
                          return;
                        }
                        context.push(AutoCropScreen.routeName);
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

                    ImageWithBadge(
                      imagePath: _backgroundImage,
                      count: _selectedMode == _modeDocument ? _pageCount : 1,
                      isMultiPage:
                          _selectedMode == _modeDocument && _isMultiPage,
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 15.h,
                  bottom: 15.h,
                ),
                height: 100.h,
                decoration: const BoxDecoration(color: Colors.white),
                child: SizedBox(
                  height: 48.h,
                  child: CustomButton(
                    text: _selectedMode == _modeIdCard
                        ? "Make it now"
                        : "Capture",
                    textColor: AllColor.white,
                    fontSize: 17.h,
                    fontWeight: FontWeight.w600,
                    backgroundColor: AllColor.primary,
                    onPressed: () {
                      setState(() {
                        if (_selectedMode == _modeIdCard) {
                          _idStep = 2;
                        } else if (_selectedMode == _modeIdPhoto) {
                          _idPhotoStep = 1;
                        }
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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

// ================== Shared widgets ==================

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

// ================== QR overlay ==================

class _QrScannerOverlay extends StatelessWidget {
  const _QrScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _QrOverlayPainter(), size: Size.infinite);
  }
}

class _QrOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fullRect = Offset.zero & size;

    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.45);
    canvas.drawRect(fullRect, overlayPaint);

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

    canvas.drawPath(holePath, Paint()..color = Colors.black.withOpacity(0.55));

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFF4B7BFF);

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ================== QR toggle ==================

class _QrBarcodeToggle extends StatelessWidget {
  final bool qrSelected;
  final ValueChanged<bool> onChanged;

  const _QrBarcodeToggle({required this.qrSelected, required this.onChanged});

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

// ================== ID card widgets ==================

class _IdA4Panel extends StatelessWidget {
  final bool bothSides;
  final String oneSideImage;
  final String bothSideImage;

  const _IdA4Panel({
    required this.bothSides,
    required this.oneSideImage,
    required this.bothSideImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 290.w,
        height: 380.h,
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              bothSides ? oneSideImage : bothSideImage,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class _IdCameraOverlay extends StatelessWidget {
  final bool bothSides;
  final String cardImage;

  const _IdCameraOverlay({required this.bothSides, required this.cardImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          'Front',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "sf_Pro",
            color: AllColor.white,
          ),
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.asset(cardImage, height: 190.h, fit: BoxFit.cover),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _SideToggle extends StatelessWidget {
  final bool bothSides;
  final ValueChanged<bool> onChanged;

  const _SideToggle({required this.bothSides, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          width: 1.w,
          color: AllColor.borderColor.withOpacity(0.55),
        ),
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

// ================== BOOK overlay ==================

class _BookOverlay extends StatelessWidget {
  final bool showSplitLine;
  const _BookOverlay({required this.showSplitLine});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BookOverlayPainter(showSplitLine: showSplitLine),
      size: Size.infinite,
    );
  }
}

class _BookOverlayPainter extends CustomPainter {
  final bool showSplitLine;
  _BookOverlayPainter({required this.showSplitLine});

  @override
  void paint(Canvas canvas, Size size) {
    final double marginH = size.width * 0.10;
    final double marginV = size.height * 0.12;

    final Rect bookRect = Rect.fromLTWH(
      marginH,
      marginV,
      size.width - marginH * 2,
      size.height - marginV * 2,
    );

    final Paint cornerPaint = Paint()
      ..color = const Color(0xFF4B7BFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double cornerLen = 26;

    canvas.drawLine(
      bookRect.topLeft,
      bookRect.topLeft + const Offset(cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      bookRect.topLeft,
      bookRect.topLeft + const Offset(0, cornerLen),
      cornerPaint,
    );

    canvas.drawLine(
      bookRect.topRight,
      bookRect.topRight + const Offset(-cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      bookRect.topRight,
      bookRect.topRight + const Offset(0, cornerLen),
      cornerPaint,
    );

    canvas.drawLine(
      bookRect.bottomLeft,
      bookRect.bottomLeft + const Offset(cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      bookRect.bottomLeft,
      bookRect.bottomLeft + const Offset(0, -cornerLen),
      cornerPaint,
    );

    canvas.drawLine(
      bookRect.bottomRight,
      bookRect.bottomRight + const Offset(-cornerLen, 0),
      cornerPaint,
    );
    canvas.drawLine(
      bookRect.bottomRight,
      bookRect.bottomRight + const Offset(0, -cornerLen),
      cornerPaint,
    );

    if (showSplitLine) {
      final Paint dashPaint = Paint()
        ..color = const Color(0xFF4B7BFF)
        ..strokeWidth = 2;

      const double dashWidth = 10;
      const double dashSpace = 7;
      final double y = bookRect.center.dy;

      double startX = bookRect.left;
      while (startX < bookRect.right) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(startX + dashWidth, y),
          dashPaint,
        );
        startX += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BookOverlayPainter oldDelegate) {
    return oldDelegate.showSplitLine != showSplitLine;
  }
}

// ================== ID PHOTO widgets ==================

class _IdPhotoExamplePanel extends StatelessWidget {
  final String badExample;
  final String goodExample;

  const _IdPhotoExamplePanel({
    required this.badExample,
    required this.goodExample,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6.h),
            Text(
              "Create Professional ID-Photo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AllColor.white,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Change background, adjust size, switch outfit and\nenhance your look",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AllColor.white,
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ExampleThumb(
                  image: badExample,
                  isGood: false,
                  showSizeLabel: false,
                ),
                SizedBox(width: 14.w),
                _ExampleThumb(
                  image: goodExample,
                  isGood: true,
                  showSizeLabel: true,
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

class _ExampleThumb extends StatelessWidget {
  final String image;
  final bool isGood;
  final bool showSizeLabel;

  const _ExampleThumb({
    required this.image,
    required this.isGood,
    required this.showSizeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110.w,
      height: 150.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.asset(image, width: 220.w, fit: BoxFit.cover),
          ),
          if (showSizeLabel)
            Positioned(
              top: 2.h,
              left: 1.sp,
              child: Text(
                "25x35mm",
                style: TextStyle(
                  fontFamily: "sf_Pro",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AllColor.black,
                ),
              ),
            ),
          Positioned(
            bottom: 6.h,
            right: 6.w,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: isGood
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGood ? Icons.check : Icons.close,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdPhotoCameraOverlay extends StatelessWidget {
  const _IdPhotoCameraOverlay();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 260.w,
        height: 340.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AllColor.primary, width: 3),
        ),
      ),
    );
  }
}

// ============ ID PHOTO bottom sheet tile (optional) ============

class _IdPhotoSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _IdPhotoSettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AllColor.primary),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "sf_Pro",
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AllColor.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
