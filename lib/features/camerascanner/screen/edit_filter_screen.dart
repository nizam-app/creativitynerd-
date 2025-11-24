import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/tools/screen/auto_crop_screen.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/marge_pdf_45.dart';
import 'package:pdf_scanner/features/tools/screen/page_organize_screen_249.dart';

import '../../../core/widget/CustomAppbar.dart';

/// ───────────────── Filter helper ─────────────────

const List<double> _greyMatrix = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];

ColorFilter? filterFromName(String name) {
  switch (name) {
    case 'Magic 1':
      return const ColorFilter.mode(Color(0x3384fff8), BlendMode.modulate);
    case 'Magic 2':
      return const ColorFilter.mode(
        Color(0x33FFA96B), // হালকা লাল টোন
        BlendMode.modulate,
      );
    case 'B&W':
      return const ColorFilter.matrix(_greyMatrix);
    default:
      return null; // Original → কোনো filter না
  }
}

/// এক ইমেজের উপর filter apply করার সাধারণ widget
class _FilteredImage extends StatelessWidget {
  final String assetPath;
  final String filterName;
  final BoxFit fit;

  const _FilteredImage({
    Key? key,
    required this.assetPath,
    required this.filterName,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(assetPath, fit: fit);
    final cf = filterFromName(filterName);
    if (cf == null) return img;
    return ColorFiltered(colorFilter: cf, child: img);
  }
}

class EditFilterScreen extends StatefulWidget {
  const EditFilterScreen({super.key, this.checkCamera = CameraCheck.camera});
  final CameraCheck checkCamera;
  static const String routeName = '/editFilter';

  @override
  State<EditFilterScreen> createState() => _EditFilterScreenState();
}

class _EditFilterScreenState extends State<EditFilterScreen> {
  int _currentPage = 1;
  int _totalPage = 2;
  int _selectedFilter = 3; // example: B&W
  bool _applyToAll = true;

  final List<_FilterItem> _filters = const [
    _FilterItem(name: 'Original'),
    _FilterItem(name: 'Magic 1'),
    _FilterItem(name: 'Magic 2'),
    _FilterItem(name: 'B&W'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: CustomEditAppBar(
        backgroundColor: AllColor.black,
        textColor: AllColor.white,
        title: "PDFScanner10-18-2025",
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () {
              if (widget.checkCamera == CameraCheck.camera)
                context.push(PageOrganizeScreen.routeName);
              else
                context.push(MargePdf45.routeName, extra: ScreenName.reorder);
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontFamily: "sf_Pro",
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: AllColor.primary,
              ),
            ),
          ),
        ],

        onBack: () => context.pop(),
      ),

      body: Column(
        children: [
          /// big preview
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: _FilteredImage(
                    assetPath: 'assets/images/filder_images.png',
                    filterName: _filters[_selectedFilter].name,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          /// bottom panel
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// page indicator + apply to all
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(11.r),
                                ),
                                child: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '$_currentPage/$_totalPage',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: "sf_Pro",
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: Checkbox(
                                value: _applyToAll,
                                onChanged: (v) {
                                  setState(() => _applyToAll = v ?? false);
                                },
                                activeColor: const Color(0xFF0A84FF),
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white54,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Apply to all',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: "sf_Pro",
                                color: AllColor.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    /// filters row
                    SizedBox(
                      height: 96.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => SizedBox(width: 10.w),
                        itemBuilder: (context, index) {
                          final f = _filters[index];
                          final bool selected = index == _selectedFilter;
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedFilter = index);
                            },
                            child: _FilterThumbnail(
                              label: f.name,
                              selected: selected,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),

                    /// bottom action buttons
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BottomActionButton(
                            icon: SvgPicture.asset(
                              'assets/images/retake_icon.svg',
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'Retake',
                          ),
                          _BottomActionButton(
                            icon: SvgPicture.asset(
                              'assets/images/rotate_icon.svg',
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'Rotate',
                          ),
                          _BottomActionButton(
                            icon: SvgPicture.asset(
                              'assets/images/crop.svg',
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'Crop',
                          ),
                          _BottomActionButton(
                            icon: SvgPicture.asset(
                              'assets/images/ocr_text.svg',
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'OCR text',
                          ),
                          _BottomActionButton(
                            icon: SvgPicture.asset(
                              'assets/images/signature.svg',
                              width: 22.w,
                              height: 22.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: 'Sign',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// simple filter model
class _FilterItem {
  final String name;
  const _FilterItem({required this.name});
}

/// filter thumbnail widget
class _FilterThumbnail extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterThumbnail({
    Key? key,
    required this.label,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isBW = label == 'B&W';

    Color borderColor = selected ? const Color(0xFF0A84FF) : Colors.transparent;

    BoxDecoration thumbDecoration;

    if (isBW) {
      // B&W – only border
      thumbDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 2),
        color: Colors.white,
      );
    } else {
      // magic / original style
      thumbDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 2),
        gradient: const LinearGradient(
          colors: [Color(0xFFED5564), Color(0xFFF5A623)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 62.w,
          height: 62.w,
          decoration: thumbDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _FilteredImage(
              assetPath: 'assets/images/original_images.png',
              filterName: label, // প্রত্যেক থাম্বে filter প্রিভিউ
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: "sf_Pro",
            color: AllColor.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// bottom action button
class _BottomActionButton extends StatelessWidget {
  final Widget icon;
  final String label;

  const _BottomActionButton({Key? key, required this.icon, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontFamily: "sf_Pro",
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../core/widget/CustomAppbar.dart';
//
// class EditFilterScreen extends StatefulWidget {
//   const EditFilterScreen({super.key});
//
//   static const String routeName = '/editFilter';
//
//   @override
//   State<EditFilterScreen> createState() => _EditFilterScreenState();
// }
//
// class _EditFilterScreenState extends State<EditFilterScreen> {
//   int _currentPage = 1;
//   int _totalPage = 2;
//   int _selectedFilter = 3; // example: B&W
//   bool _applyToAll = true;
//
//   final List<_FilterItem> _filters = const [
//     _FilterItem(name: 'Original'),
//     _FilterItem(name: 'Magic 1'),
//     _FilterItem(name: 'Magic 2'),
//     _FilterItem(name: 'B&W'),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // whole screen dark
//
//       appBar: CustomEditAppBar(
//         backgroundColor: AllColor.black,
//         textColor: AllColor.white,
//
//         title: "PDFScanner10-18-2025",
//         centerTitle: true,
//         actionText: 'Done',
//         // onActionTap: () => Navigator.of(context).pop(_current),
//         onBack: () => Navigator.of(context).pop(),
//       ),
//
//       body: Column(
//         children: [
//           /// big preview
//           Expanded(
//             child: Center(
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.r),
//                   child: Image.asset(
//                     'assets/images/filder_images.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           /// bottom panel
//           SafeArea(
//             top: false,
//             child: Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF111111),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     /// page indicator + apply to all
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 10.w, vertical: 4.h),
//                           decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius: BorderRadius.circular(14.r),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 22.w,
//                                 height: 22.w,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.08),
//                                   borderRadius: BorderRadius.circular(11.r),
//                                 ),
//                                 child: Icon(
//                                   CupertinoIcons.back,
//                                   color: Colors.white,
//                                   size: 14.sp,
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               Text(
//                                 '$_currentPage/$_totalPage',
//                                 style: TextStyle(
//                                   fontSize: 13.sp,
//                                   fontFamily: "sf_Pro",
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: 18.w,
//                               height: 18.w,
//                               child: Checkbox(
//                                 value: _applyToAll,
//                                 onChanged: (v) {
//                                   setState(() => _applyToAll = v ?? false);
//                                 },
//                                 activeColor: const Color(0xFF0A84FF),
//                                 checkColor: Colors.white,
//                                 side: const BorderSide(
//                                   color: Colors.white54,
//                                   width: 1.2,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4.r),
//                                 ),
//                                 materialTapTargetSize:
//                                 MaterialTapTargetSize.shrinkWrap,
//                               ),
//                             ),
//                             SizedBox(width: 6.w),
//                             Text(
//                               'Apply to all',
//                               style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontFamily: "sf_Pro",
//                                 color: AllColor.white,
//                                 fontWeight: FontWeight.w500
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10.h),
//
//                     /// filters row
//                     SizedBox(
//                       height: 96.h,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _filters.length,
//                         separatorBuilder: (_, __) => SizedBox(width: 10.w),
//                         itemBuilder: (context, index) {
//                           final f = _filters[index];
//                           final bool selected = index == _selectedFilter;
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() => _selectedFilter = index);
//                             },
//                             child: _FilterThumbnail(
//                               label: f.name,
//                               selected: selected,
//                               isBW: f.name == 'B&W',
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//
//                     /// bottom action buttons
//                     Padding(
//                       padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _BottomActionButton(
//                             icon: SvgPicture.asset(
//                               'assets/images/retake_icon.svg',
//                               width: 22.w,
//                               height: 22.h,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.white,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             label: 'Retake',
//                           ),
//                           _BottomActionButton(
//                             icon: SvgPicture.asset(
//                               'assets/images/rotate_icon.svg',
//                               width: 22.w,
//                               height: 22.h,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.white,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             label: 'Rotate',
//                           ),
//                           _BottomActionButton(
//                             icon: SvgPicture.asset(
//                               'assets/images/crop.svg',
//                               width: 22.w,
//                               height: 22.h,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.white,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             label: 'Crop',
//                           ),
//                           _BottomActionButton(
//                             icon: SvgPicture.asset(
//                               'assets/images/ocr_text.svg',
//                               width: 22.w,
//                               height: 22.h,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.white,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             label: 'OCR text',
//                           ),
//                           _BottomActionButton(
//                             icon: SvgPicture.asset(
//                               'assets/images/signature.svg',
//                               width: 22.w,
//                               height: 22.h,
//                               colorFilter: const ColorFilter.mode(
//                                 Colors.white,
//                                 BlendMode.srcIn,
//                               ),
//                             ),
//                             label: 'Sign',
//                           ),
//                         ],
//                       )
//
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// simple filter model
// class _FilterItem {
//   final String name;
//   const _FilterItem({required this.name});
// }
//
// /// filter thumbnail widget
// class _FilterThumbnail extends StatelessWidget {
//   final String label;
//   final bool selected;
//   final bool isBW;
//
//   const _FilterThumbnail({
//     Key? key,
//     required this.label,
//     required this.selected,
//     this.isBW = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Color borderColor =
//     selected ? const Color(0xFF0A84FF) : Colors.transparent;
//
//     BoxDecoration thumbDecoration;
//
//     if (isBW) {
//       // B&W – only border
//       thumbDecoration = BoxDecoration(
//         borderRadius: BorderRadius.circular(14.r),
//         border: Border.all(color: borderColor, width: 2),
//         color: Colors.white,
//       );
//     } else {
//       // magic / original style
//       thumbDecoration = BoxDecoration(
//         borderRadius: BorderRadius.circular(14.r),
//         border: Border.all(color: borderColor, width: 2),
//         gradient: const LinearGradient(
//           colors: [
//             Color(0xFFED5564),
//             Color(0xFFF5A623),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       );
//     }
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 62.w,
//           height: 62.w,
//           decoration: thumbDecoration,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12.r),
//             child: Image.asset(
//               'assets/images/original_images.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         SizedBox(height: 6.h),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11.sp,
//             fontFamily: "sf_Pro",
//             color: AllColor.white,
//             fontWeight: FontWeight.w400
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// /// bottom action button
// class _BottomActionButton extends StatelessWidget {
//   final Widget icon;
//   final String label;
//
//   const _BottomActionButton({
//     Key? key,
//     required this.icon,
//     required this.label,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         icon,
//         SizedBox(height: 4.h),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11.sp,
//             fontFamily: "sf_Pro",
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
