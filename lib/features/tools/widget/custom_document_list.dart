// lib/features/tools/widget/custom_document_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/data/ducment_selecd_data.dart';
import 'package:pdf_scanner/features/tools/screen/model/document_list_model.dart';

class DocumentSelectionNotifier extends StateNotifier<Set<int>> {
  DocumentSelectionNotifier() : super(<int>{});

  void toggle(int index) {
    final newSet = {...state};
    if (newSet.contains(index)) {
      newSet.remove(index);
    } else {
      newSet.add(index);
    }
    state = newSet;
  }

  void clear() => state = <int>{};
}

class CustomDocumentList extends ConsumerWidget {
  final List<DocumentItem> documents;

  /// true => show "Import from other app" card
  final bool isFromShow;

  /// true => arrow icon (look screen),
  /// false => circle + check (multi select) => image 1 design
  final bool isShowLook;

  final VoidCallback? onMyDeviceTap;
  final VoidCallback? onImportFromOtherAppTap;

  /// every tap
  final ValueChanged<DocumentItem>? onDocumentTap;

  /// full selected docs list
  final ValueChanged<List<DocumentItem>>? onSelectionChanged;

  const CustomDocumentList({
    Key? key,
    required this.documents,
    this.isFromShow = false,
    this.isShowLook = false,
    this.onMyDeviceTap,
    this.onImportFromOtherAppTap,
    this.onDocumentTap,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(documentSelectionProvider);

    void handleDocTap(int index) {
      final doc = documents[index];

      // multi-select mode (circle design)
      if (!isShowLook) {
        ref.read(documentSelectionProvider.notifier).toggle(index);

        if (onSelectionChanged != null) {
          final currentSet = ref.read(documentSelectionProvider);
          onSelectionChanged!(
            currentSet.map((i) => documents[i]).toList(growable: false),
          );
        }
      }

      onDocumentTap?.call(doc);
    }

    return Container(
      // color: const Color(0xFFF4F7FB),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Document',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AllColor.black,
            ),
          ),
          SizedBox(height: 8.h),

          _MyDeviceTile(onTap: onMyDeviceTap),

          if (isFromShow) SizedBox(height: 8.h),

          if (isFromShow)
            _ImportFromOtherAppTile(onTap: onImportFromOtherAppTap),

          SizedBox(height: 16.h),

          ...List.generate(documents.length, (index) {
            final doc = documents[index];
            final selected = selectedIndexes.contains(index);

            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _DocumentRow(
                item: doc,
                showArrow: isShowLook,
                selected: selected,
                onTap: () => handleDocTap(index),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// ----- My Device card -----
class _MyDeviceTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _MyDeviceTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/tool/Group4496.svg',
              width: 58.w,
              height: 58.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'My Device',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFB0B6C5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// ----- Import from other app card -----
class _ImportFromOtherAppTile extends StatelessWidget {
  final VoidCallback? onTap;

  const _ImportFromOtherAppTile({this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EEFF),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                Icons.insert_drive_file_rounded,
                color: const Color(0xFF3F63E8),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'Import from other app',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFB0B6C5),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// ----- Single document row (same design as image 1) -----
class _DocumentRow extends StatelessWidget {
  final DocumentItem item;
  final bool showArrow;
  final bool selected;
  final VoidCallback? onTap;

  const _DocumentRow({
    required this.item,
    required this.showArrow,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        height: 82.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 12.h),
        child: Row(
          children: [
            // thumbnail
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2.r)),
              child:
                  item.thumbnail ??
                  Image.asset(
                    'assets/images/tool/Rectangle7.png',
                    width: 56.w,
                    height: 56.h,
                  ),
            ),
            SizedBox(width: 12.w),

            // title + info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AllColor.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item.pages} pages • ${item.size}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),

            // trailing
            if (showArrow)
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFFB0B6C5),
                size: 24.sp,
              )
            else
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? ToolFlowColor.royal_Blue
                      : AllColor.white, // filled blue when selected
                  border: Border.all(
                    color: selected
                        ? ToolFlowColor.royal_Blue
                        : ToolFlowColor.coolGery,
                    width: 2.w,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                    : const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}
