import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';
import 'package:pdf_scanner/core/widget/globalCustomButton.dart';
import 'package:pdf_scanner/features/tools/screen/Congratulations_screen.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/data/ducment_selecd_data.dart';
import 'package:pdf_scanner/features/tools/screen/model/document_list_model.dart';
import 'package:pdf_scanner/features/tools/widget/custom_document_list.dart';
import 'package:pdf_scanner/features/tools/widget/custom_merge_pdf_alart.dart';
import 'package:pdf_scanner/features/tools/widget/custom_top_back_button.dart';

enum ScreenName { marge, split, lock, unlock, reorder }

extension ScreenNameText on ScreenName {
  String get title {
    switch (this) {
      case ScreenName.marge:
        return 'Marge PDF';
      case ScreenName.split:
        return 'Split PDF';
      case ScreenName.lock:
        return 'Lock PDF';
      case ScreenName.unlock:
        return 'Unlock PDF';
      case ScreenName.reorder:
        return 'Reorder pages';
    }
  }
}

class MargePdf45 extends ConsumerWidget {
  static final routeName = '/margePdf45';
  final ScreenName isCheckScreenName;
  const MargePdf45({super.key, required this.isCheckScreenName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndexes = ref.watch(documentSelectionProvider);
    final selectedCount = selectedIndexes.length;

    final bool hasSelection = selectedCount > 0;

    return Scaffold(
      backgroundColor: ToolFlowColor.backGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBarBackButton(title: isCheckScreenName.title),
            if (isCheckScreenName == ScreenName.marge ||
                isCheckScreenName == ScreenName.lock ||
                isCheckScreenName == ScreenName.unlock)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomDocumentList(
                        documents: [
                          DocumentItem(
                            title: '04 Aug, document 1',
                            pages: 25,
                            size: '536 KB',
                          ),
                          DocumentItem(
                            title: '04 Aug, document 2',
                            pages: 12,
                            size: '210 KB',
                          ),
                          DocumentItem(
                            title: '04 Aug, document 3',
                            pages: 8,
                            size: '120 KB',
                          ),
                        ],
                        isFromShow:
                            isCheckScreenName == ScreenName.lock ||
                                isCheckScreenName == ScreenName.unlock
                            ? true
                            : false,
                        showLock: isCheckScreenName == ScreenName.unlock
                            ? true
                            : false,
                        showArrow: isCheckScreenName == ScreenName.unlock
                            ? true
                            : false,

                        onDocumentTap: (doc) async {
                          if (isCheckScreenName == ScreenName.unlock) {
                            final name = await showMergePdfNameDialog(
                              context,
                              screenName: isCheckScreenName,
                            );
                            if (name != null && name.isNotEmpty) {
                              context.push(
                                CongratulationsScreen.routeName,
                                extra: isCheckScreenName,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 25.h, 16.w, 2.h),
                      child: Text(
                        'Select Page',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9BA4B5),
                        ),
                      ),
                    ),

                    // নিচের অংশ vertical scroll হবে
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // প্রতি row-তে 2টা পেজ
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: (180.w / 240.h),
                        ),
                        itemCount: 10, // যত পেজ আছে সেট করো
                        itemBuilder: (context, index) {
                          final selected = selectedIndexes.contains(index);

                          return CusotmSplitPdf(
                            thumbnail: Image.asset(
                              'assets/images/tool/maiye.png',
                              fit: BoxFit.cover,
                            ),
                            isSelected: selected,
                            screenName: isCheckScreenName,

                            onTap: () {
                              ref
                                  .read(documentSelectionProvider.notifier)
                                  .toggle(index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AllColor.white,
          border: Border(top: BorderSide(color: ToolFlowColor.lightGray)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        height: 80.h,
        child: GlobalCustomButton(
          title: 'Continue($selectedCount)',
          backgroundColor: hasSelection
              ? ToolFlowColor
                    .royal_Blue // গাঢ় নীল (selected থাকলে)
              : ToolFlowColor.royal_Blue.withOpacity(
                  0.45,
                ), // হালকা নীল (selected না থাকলে)
          onPressed: () async {
            if (!hasSelection) return;
            final name = await showMergePdfNameDialog(
              context,
              screenName: isCheckScreenName,
            );
            if (name != null && name.isNotEmpty) {
              context.push(
                CongratulationsScreen.routeName,
                extra: isCheckScreenName,
              );
            }
          },
        ),
      ),
    );
  }
}

class CusotmSplitPdf extends StatelessWidget {
  final Widget thumbnail; // PDF page preview image
  final bool isSelected; // true = blue check, false = empty circle
  final VoidCallback? onTap;
  final double? width;
  final ScreenName screenName;

  const CusotmSplitPdf({
    super.key,
    required this.thumbnail,
    this.isSelected = false,
    this.onTap,
    this.width,
    this.screenName = ScreenName.split,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = width ?? 180.w;
    final double cardHeight = 240.h;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        width: cardWidth,
        height: cardHeight,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.black.withOpacity(0.12), // 0.12 opacity border
            width: 1,
          ),
          color: Colors.white, // চান না হলে বাদ দাও
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            children: [
              // full image
              Positioned.fill(child: thumbnail),

              // bottom overlay (image-এর উপরেই)
              if (screenName != ScreenName.reorder)
                ?Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 44.h,
                    color: Colors.black.withOpacity(0.30),
                  ),
                ),

              // selection circle bottom-right
              if (screenName != ScreenName.reorder)
                ?Positioned(
                  right: 12.w,
                  bottom: 10.h,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFF4E6BFA) // selected fill (blue)
                          : Colors.white, // unselected fill
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4E6BFA)
                            : const Color(0xFFD1D7E3),
                        width: 2.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                        : const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
