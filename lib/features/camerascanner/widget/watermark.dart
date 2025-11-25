import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';

import '../../../core/constants/color_control/tool_flow_color.dart';

Future<String?> showAddTextBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddTextBottomSheet(),
  );
}

/// ================== BOTTOM SHEET ==================

class _AddTextBottomSheet extends StatefulWidget {
  const _AddTextBottomSheet({super.key});

  @override
  State<_AddTextBottomSheet> createState() => _AddTextBottomSheetState();
}

class _AddTextBottomSheetState extends State<_AddTextBottomSheet> {
  double _fontSize = 12;
  final TextEditingController _controller = TextEditingController();

  // alignment state (local)
  bool _isAlignMenuOpen = false;
  TextAlign _textAlign = TextAlign.left;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() => Navigator.pop(context);

  void _submit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ToolFlowColor.backGroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------------- TOP BAR ----------------
                Row(
                  children: [
                    GestureDetector(
                      onTap: _close,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'sf_Pro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: AllColor.borderColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Add text',
                      style: TextStyle(
                        fontFamily: 'sf_Pro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AllColor.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _submit,
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: 'sf_Pro',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: AllColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // ---------------- TOP CONTROLS ROW ----------------
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // ALIGN + POPUP (exactly like screenshot)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAlignMenuOpen = !_isAlignMenuOpen;
                              });
                            },
                            child: _SegmentBox(
                              isActive: _isAlignMenuOpen,
                              child: Row(
                                children: [
                                  _AlignLinesIcon(
                                    align: _textAlign,
                                    color: _isAlignMenuOpen
                                        ? Colors.white
                                        : AllColor.black,
                                  ),
                                  SizedBox(width: 6.w),
                                  Icon(
                                    _isAlignMenuOpen
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 16.sp,
                                    color: AllColor.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // popup bubble
                          if (_isAlignMenuOpen)
                            Positioned(
                              top: 40.h, // টুলবারের খুব কাছে
                              left: 0,
                              child: _AlignPopup(
                                selected: _textAlign,
                                onSelected: (align) {
                                  setState(() {
                                    _textAlign = align;
                                    _isAlignMenuOpen = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),

                      SizedBox(width: 8.w),

                      // Font size with - 12 pt +
                      _SegmentBox(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_fontSize > 8) _fontSize--;
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                size: 16.sp,
                                color: AllColor.primary,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${_fontSize.toInt()} pt',
                              style: TextStyle(
                                fontFamily: 'sf_Pro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AllColor.black,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _fontSize++;
                                });
                              },
                              child: Icon(
                                Icons.add,
                                size: 16.sp,
                                color: AllColor.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // Font family box
                      _SegmentBox(
                        child: Row(
                          children: [
                            Text(
                              'SF Pro',
                              style: TextStyle(
                                fontFamily: 'sf_Pro',
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: AllColor.black,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16.sp,
                              color: AllColor.primary,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 8.w),

                      const ColorCircleDropdownIcon(),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                // ---------------- TEXT AREA ----------------
                Container(
                  width: double.infinity,
                  height: 220.h,
                  decoration: BoxDecoration(
                    color: AllColor.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    textAlign: _textAlign,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontFamily: 'sf_Pro',
                      fontSize: _fontSize.sp,
                      color: AllColor.borderColor,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      hintText: 'Type here',
                      hintStyle: TextStyle(
                        fontFamily: 'sf_Pro',
                        fontSize: 17.sp,
                        color: AllColor.borderColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================== COLOR CIRCLE ICON ==================

class ColorCircleDropdownIcon extends StatelessWidget {
  const ColorCircleDropdownIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer black ring
          Container(
            width: 34.w,
            height: 34.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.black,
            ),
          ),

          // White ring
          Container(
            width: 28.w,
            height: 28.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.white,
            ),
          ),

          // Inner black filled circle
          Container(
            width: 22.w,
            height: 22.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.black,
            ),
          ),

          // Blue V arrow
          Transform.rotate(
            angle: math.pi,
            child: Icon(
              Icons.expand_less,
              size: 14.sp,
              color: AllColor.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================== SEGMENT BOX ==================

class _SegmentBox extends StatelessWidget {
  final Widget child;
  final double? width;
  final bool isActive;

  const _SegmentBox({
    required this.child,
    this.width,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE2E7F9) : AllColor.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

/// ================== ALIGN POPUP (4 options) ==================

class _AlignPopup extends StatelessWidget {
  final TextAlign selected;
  final ValueChanged<TextAlign> onSelected;

  const _AlignPopup({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ছোট arrow – bubble এর সাথে লাগানো
        Transform.translate(
          offset: Offset(0, 2.h),
          child: Icon(
            Icons.arrow_drop_up,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AlignOption(
                align: TextAlign.left,
                isSelected: selected == TextAlign.left,
                onTap: () => onSelected(TextAlign.left),
              ),
              SizedBox(width: 4.w),
              _AlignOption(
                align: TextAlign.center,
                isSelected: selected == TextAlign.center,
                onTap: () => onSelected(TextAlign.center),
              ),
              SizedBox(width: 4.w),
              _AlignOption(
                align: TextAlign.right,
                isSelected: selected == TextAlign.right,
                onTap: () => onSelected(TextAlign.right),
              ),
              SizedBox(width: 4.w),
              _AlignOption(
                align: TextAlign.justify,
                isSelected: selected == TextAlign.justify,
                onTap: () => onSelected(TextAlign.justify),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlignOption extends StatelessWidget {
  final TextAlign align;
  final bool isSelected;
  final VoidCallback onTap;

  const _AlignOption({
    required this.align,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF3478F6); // iOS blue
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF3F4F7),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: _AlignLinesIcon(
            align: align,
            color: isSelected ? Colors.white : const Color(0xFF27323A),
          ),
        ),
      ),
    );
  }
}

/// tiny 3-line icon used for alignment

class _AlignLinesIcon extends StatelessWidget {
  final TextAlign align;
  final Color color;

  const _AlignLinesIcon({
    required this.align,
    required this.color,
  });

  Alignment _alignment() {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _line(align == TextAlign.justify ? Alignment.center : _alignment()),
          SizedBox(height: 3.h),
          _line(align == TextAlign.justify ? Alignment.center : _alignment()),
          SizedBox(height: 3.h),
          _line(align == TextAlign.justify ? Alignment.center : _alignment()),
        ],
      ),
    );
  }

  Widget _line(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        height: 2.h,
        width: 16.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999.r),
        ),
      ),
    );
  }
}


// import 'dart:math' as math;
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
//
// import '../../../core/constants/color_control/tool_flow_color.dart';
//
//
// Future<String?> showAddTextBottomSheet(BuildContext context) {
//   return showModalBottomSheet<String>(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => const _AddTextBottomSheet(),
//   );
// }
//
// class _AddTextBottomSheet extends StatefulWidget {
//   const _AddTextBottomSheet({super.key});
//
//   @override
//   State<_AddTextBottomSheet> createState() => _AddTextBottomSheetState();
// }
//
// class _AddTextBottomSheetState extends State<_AddTextBottomSheet> {
//   double _fontSize = 12;
//   final TextEditingController _controller = TextEditingController();
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: EdgeInsets.only(
//         // make sheet go above keyboard
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: ToolFlowColor.backGroundColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20.r),
//             topRight: Radius.circular(20.r),
//           ),
//         ),
//         child: SafeArea(
//           top: false,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ---------------- TOP BAR ----------------
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context),
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(
//                           fontFamily: 'sf_Pro',
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w400,
//                           color: AllColor.borderColor,
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     Text(
//                       'Add text',
//                       style: TextStyle(
//                         fontFamily: 'sf_Pro',
//                         fontSize: 17.sp,
//                         fontWeight: FontWeight.w600,
//                         color: AllColor.black,
//                       ),
//                     ),
//                     const Spacer(),
//                     GestureDetector(
//                       onTap: () => Navigator.pop(context, _controller.text),
//                       child: Text(
//                         'Done',
//                         style: TextStyle(
//                           fontFamily: 'sf_Pro',
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w600,
//                           color: AllColor.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 14.h),
//
//                 // ---------------- TOP CONTROLS ROW ----------------
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       // Align dropdown
//                       _SegmentBox(
//                         child: Row(
//                           children: [
//                             Icon(Icons.format_align_left,
//                                 size: 20.sp, color: AllColor.black),
//                             SizedBox(width: 6.w),
//                             Icon(Icons.keyboard_arrow_down,
//                                 size: 16.sp, color: AllColor.primary),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//
//                       // Font size with - 12 pt +
//                       _SegmentBox(
//                         child: Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   if (_fontSize > 8) _fontSize--;
//                                 });
//                               },
//                               child: Icon(Icons.remove,
//                                   size: 16.sp, color: AllColor.primary),
//                             ),
//                             SizedBox(width: 4.w),
//                             Text(
//                               '${_fontSize.toInt()} pt',
//                               style: TextStyle(
//                                 fontFamily: 'sf_Pro',
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: AllColor.black,
//                               ),
//                             ),
//                             SizedBox(width: 4.w),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _fontSize++;
//                                 });
//                               },
//                               child: Icon(Icons.add,
//                                   size: 16.sp, color: AllColor.primary),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       // Font family dropdown
//                       _SegmentBox(
//                         child: Row(
//                           children: [
//                             Text(
//                               'SF Pro',
//                               style: TextStyle(
//                                 fontFamily: 'sf_Pro',
//                                 fontSize: 17.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: AllColor.black,
//                               ),
//                             ),
//                             SizedBox(width: 6.w),
//                             Icon(Icons.keyboard_arrow_down,
//                                 size: 16.sp, color: AllColor.primary),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       ColorCircleDropdownIcon(),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: 14.h),
//
//                 // ---------------- TEXT AREA ----------------
//                 Container(
//                   width: double.infinity,
//                   height: 220.h,
//                   decoration: BoxDecoration(
//                     color: AllColor.white,            // outer background
//                     borderRadius: BorderRadius.circular(16.r),
//                   ),
//                   child: TextField(
//                     controller: _controller,
//                     maxLines: null,
//                     keyboardType: TextInputType.multiline,
//                     style: TextStyle(
//                       fontFamily: 'sf_Pro',
//                       fontSize: 17.sp,
//                       color: AllColor.borderColor,    // typing text color
//                       fontWeight: FontWeight.w400,
//                     ),
//                     decoration: InputDecoration(
//                       isCollapsed: true,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 10.h,
//                       ),
//                       hintText: 'Type here',
//                       hintStyle: TextStyle(
//                         fontFamily: 'sf_Pro',
//                         fontSize: 17.sp,
//                         color: AllColor.borderColor,  // hint text color
//                       ),
//
//                       // ---- সব border pure white রাখা হলো ----
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.r),
//                         borderSide: const BorderSide(
//                           color: AllColor.white,
//                           width: 1,
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.r),
//                         borderSide: const BorderSide(
//                           color: Colors.white,
//                           width: 1,
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16.r),
//                         borderSide: const BorderSide(
//                           color: Colors.white,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ColorCircleDropdownIcon extends StatelessWidget {
//   const ColorCircleDropdownIcon({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 34.w,
//       height: 34.w,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // Outer black ring
//           Container(
//             width: 34.w,
//             height: 34.w,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: AllColor.black,
//             ),
//           ),
//
//           // White ring
//           Container(
//             width: 28.w,
//             height: 28.w,
//             decoration:  BoxDecoration(
//               shape: BoxShape.circle,
//               color: AllColor.white,
//             ),
//           ),
//
//           // Inner black filled circle
//           Container(
//             width: 22.w,
//             height: 22.w,
//             decoration:  BoxDecoration(
//               shape: BoxShape.circle,
//               color: AllColor.black,
//             ),
//           ),
//
//           // Blue V arrow
//           Transform.rotate(
//             angle: math.pi,
//             child: Icon(
//               Icons.expand_less,
//               size: 14.sp,
//               color:  AllColor.primary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// /// Small rounded white segment like the screenshot controls row
// class _SegmentBox extends StatelessWidget {
//   final Widget child;
//   final double? width;
//
//   const _SegmentBox({
//     required this.child,
//     this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 38.h,
//       width: width,
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       decoration: BoxDecoration(
//         color: AllColor.white,
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(
//           color: AllColor.white,
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white,
//             blurRadius: 4,
//             offset:  Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Center(child: child),
//     );
//   }
// }
