import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Add this import
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';
import 'package:pdf_scanner/core/widget/globalCustomButton.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/data/ducment_selecd_data.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/Congratulations_screen.dart';
import 'package:pdf_scanner/features/tools/screen/model/document_list_model.dart';
import 'package:pdf_scanner/features/tools/widget/custom_document_list.dart';
import 'package:pdf_scanner/features/tools/widget/custom_merge_pdf_alart.dart';
import 'package:pdf_scanner/features/tools/widget/custom_top_back_button.dart';

class MargePdf45 extends ConsumerWidget {
  static final routeName = '/margePdf45';
  const MargePdf45({super.key});

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
            CustomTopBarBackButton(title: 'Marge PDF'),
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
                      isFromShow: false,
                      isShowLook: false,
                      onDocumentTap: (doc) {},
                    ),
                  ],
                ),
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
            if (!hasSelection) return; // কিছু সিলেক্ট না হলে কাজ করবে না
            final name = await showMergePdfNameDialog(context);
            if (name != null && name.isNotEmpty) {
              context.push(CongratulationsScreen.routeName);
            }
          },
        ),
      ),
    );
  }
}
