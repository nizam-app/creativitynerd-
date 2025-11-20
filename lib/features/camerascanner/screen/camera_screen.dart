import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/edit_filter_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  static const String routeName = '/cameraScanner';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  int _selectedMode = 0;
  final List<String> _modes = [
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

  // --- new state for page mode & photos ---
  bool _isMultiPage = false;
  final List<XFile> _capturedFiles = [];
  int _currentPageIndex = 0; // 0-based

  final _picker = ImagePicker();

  // @override
  // void initState() {
  //   super.initState();
  //   _initCamera();
  // }
  //
  // Future<void> _initCamera() async {
  //   try {
  //     final cameras = await availableCameras();
  //
  //     final backCamera = cameras.firstWhere(
  //           (c) => c.lensDirection == CameraLensDirection.back,
  //       orElse: () => cameras.first,
  //     );
  //
  //     _cameraController = CameraController(
  //       backCamera,
  //       ResolutionPreset.high,
  //       enableAudio: false,
  //     );
  //
  //     _initializeControllerFuture = _cameraController!.initialize();
  //     await _initializeControllerFuture;
  //
  //     if (!mounted) return;
  //
  //     setState(() {
  //       _isCameraReady = true;
  //     });
  //   } catch (e) {
  //     debugPrint('Camera init error: $e');
  //     if (!mounted) return;
  //     setState(() {
  //       _isCameraReady = false;
  //     });
  //   }
  // }
  //
  // Future<void> _captureImage() async {
  //   if (_cameraController == null ||
  //       !_cameraController!.value.isInitialized ||
  //       _cameraController!.value.isTakingPicture) {
  //     return;
  //   }
  //
  //   try {
  //     await _initializeControllerFuture;
  //     final file = await _cameraController!.takePicture();
  //
  //     setState(() {
  //       if (_isMultiPage) {
  //         _capturedFiles.add(file);
  //       } else {
  //         _capturedFiles
  //           ..clear()
  //           ..add(file);
  //       }
  //       _currentPageIndex = _capturedFiles.isEmpty
  //           ? 0
  //           : _capturedFiles.length - 1; // last page
  //     });
  //
  //     debugPrint('Captured image path: ${file.path}');
  //   } catch (e) {
  //     debugPrint('Capture error: $e');
  //   }
  // }
  //
  // Future<void> _pickFromGallery() async {
  //   try {
  //     final picked = await _picker.pickMultiImage(); // multiple image
  //     if (picked.isEmpty) return;
  //
  //     setState(() {
  //       if (_isMultiPage) {
  //         _capturedFiles.addAll(picked);
  //       } else {
  //         _capturedFiles
  //           ..clear()
  //           ..add(picked.first);
  //       }
  //       _currentPageIndex = _capturedFiles.isEmpty
  //           ? 0
  //           : _capturedFiles.length - 1;
  //     });
  //
  //     debugPrint('Gallery images count: ${picked.length}');
  //   } catch (e) {
  //     debugPrint('Gallery pick error: $e');
  //   }
  // }
  //
  String get _pageCounterText {
    if (_capturedFiles.isEmpty) return '0/0';
    return '${_currentPageIndex + 1}/${_capturedFiles.length}';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _showResolutionPopup(BuildContext context) {
    showMenu(
      color: AllColor.gery100.withOpacity(0.60), // Background color
      context: context,
      position: RelativeRect.fromLTRB(100, 105, 100, 100),
      elevation: 8.0,
      items: [
        PopupMenuItem<String>(
          value: '12M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: AllColor.white), // Done icon on the left
                  SizedBox(width: 8.w), // Spacing between icon and text
                  Text("12M (3968x2976)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2),), // Divider added below text
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '8M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: Colors.transparent), // Placeholder for unselected
                  SizedBox(width: 8.w),
                  Text("8M (3840x2160)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2),),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '5M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  Text("5M (3072x1728)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2),),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '4M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  Text("4M (2560x1920)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2),),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '2M',
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check, color: Colors.transparent),
                  SizedBox(width: 8.w),
                  Text("2M (1920x1088)"),
                ],
              ),
              Divider(color: AllColor.gery.withOpacity(0.2),),
            ],
          ),
        ),
      ],

    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.push(CropScreen.routeName);
                    },
                    iconSize: 22.sp,
                    icon: SvgPicture.asset(
                      'assets/images/crop.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter:  ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      _showResolutionPopup(context);
                    },
                    iconSize: 22.sp,
                    icon: SvgPicture.asset(
                      'assets/images/hq.svg',
                      width: 22.w,
                      height: 22.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                IconButton(
                  onPressed: () {
                    _showCustomPopupMenu(context);

                  },
                  iconSize: 22.sp, // optional
                  icon: SvgPicture.asset(
                    'assets/images/charge.svg',
                    width: 22.w,
                    height: 22.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
    ]
              ),

            ),

            // CAMERA PREVIEW AREA
            Expanded(
              child: Padding(
                padding:  EdgeInsets.only(bottom: 10.h,),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                    //  borderRadius: BorderRadius.circular(20.r),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child:
                          Image.asset("assets/images/camera_image.png", fit: BoxFit.cover,)
                        // _isCameraReady && _cameraController != null
                        //     ? CameraPreview(_cameraController!)
                        //     : Container(
                        //   color: Colors.grey.shade900,
                        //   child: Center(
                        //     child: _cameraController == null
                        //         ? const CircularProgressIndicator(
                        //       color: Colors.white,
                        //     )
                        //         : const Icon(
                        //       Icons.camera_alt_outlined,
                        //       color: AllColor.white24,
                        //       size: 40,
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),

                    // Single / Multi page pill
                    Positioned(
                      bottom: 40.h,
                      child: Container(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 14.w, vertical: 6.h),
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
                                  // optional: single mode e gele last image rakhte chao naki clear korba?
                                  if (_capturedFiles.length > 1) {
                                    final last = _capturedFiles.last;
                                    _capturedFiles
                                      ..clear()
                                      ..add(last);
                                    _currentPageIndex = 0;
                                  }
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
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Mode tabs bottom
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
                            onTap: () {
                              setState(() => _selectedMode = index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM CONTROLS
            Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.h,
                bottom: 24.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery button
                  InkWell(
                    //onTap: _pickFromGallery,
                    onTap: (){
                      context.push(EditFilterScreen.routeName);
                    },
                  //  borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                    //  padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                     //   color: Colors.white10,
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
                 //   onTap: _captureImage,
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
                        Center(
    child: ImageWithBadge(
    imagePath: 'assets/images/camera_image.png',
    count: 1,
    ),
    ),

                  // Page count / layers
                  // InkWell(
                  //   onTap: () {
                  //     // TODO: open captured pages list / preview
                  //   },
                  //   borderRadius: BorderRadius.circular(12.r),
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 10.w,
                  //       vertical: 8.h,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white10,
                  //       borderRadius: BorderRadius.circular(12.r),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.layers_outlined,
                  //           color: Colors.white,
                  //           size: 18.sp,
                  //         ),
                  //         SizedBox(width: 6.w),
                  //         Text(
                  //           _pageCounterText, // <-- dynamic count
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 13.sp,
                  //             fontFamily: 'sf_Pro',
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
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
            color: AllColor.white ,
          ),
        ),
      ),
    );
  }

  void _showCustomPopupMenu(BuildContext context) {

      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100,105, 10, 200),
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
  }



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
              color: selected ? AllColor.primary : AllColor.white,
            ),
          ),
          SizedBox(height: 4.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20.w,
            height: 3.h,
            decoration: BoxDecoration(
              color: selected ? AllColor.white :AllColor.black,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}




class ImageWithBadge extends StatelessWidget {
  final String imagePath; // asset path
  final int count;

  const ImageWithBadge({
    Key? key,
    required this.imagePath,
    required this.count,
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
          // main image (rounded)
          ClipRRect(
            borderRadius: BorderRadius.circular(11.r),
            child: Image.asset(
              imagePath,
              width: 44.w,
              height: 55.h,
              fit: BoxFit.cover,
            ),
          ),

          // red badge bottom-center
          Positioned(
            bottom: 0.h,
            left: -10.h,
            top: 0,
            child: Center(
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration:  BoxDecoration(
                  color: AllColor.red,
                  borderRadius: BorderRadius.all(Radius.circular(100.r))
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: "sf_Pro"
                    ),
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

