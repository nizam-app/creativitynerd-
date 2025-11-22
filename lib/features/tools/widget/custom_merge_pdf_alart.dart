import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';

Future<String?> showMergePdfNameDialog(BuildContext context) async {
  final controller = TextEditingController();

  final result = await showCupertinoDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _MergePdfNameAlert(controller: controller),
  );

  controller.dispose();
  return result; // null == cancel, otherwise filename
}

class _MergePdfNameAlert extends StatelessWidget {
  final TextEditingController controller;

  const _MergePdfNameAlert({required this.controller});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 270.w,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ----- Title + content -----
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Merge PDF',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'PDF File Name',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: ToolFlowColor.black,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    CupertinoTextField(
                      cursorHeight: 32.h,
                      cursorWidth: 238.w,
                      controller: controller,
                      placeholder: 'Enter file name....',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: CupertinoColors.separator),

              // ----- Bottom buttons (Cancel | Ok) -----
              SizedBox(
                height: 48.h,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          context.pop();
                          final discard = await showDiscardConfirmDialog(
                            context,
                          );
                          if (discard == true) {
                            context.pop();
                          } else {
                            context.pop();
                          }
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: CupertinoColors.separator),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop(controller.text.trim());
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showDiscardConfirmDialog(BuildContext context) {
  return showCupertinoDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _DiscardAlert(),
  );
}

class _DiscardAlert extends StatelessWidget {
  const _DiscardAlert();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 280.w,
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -------- title + content ----------
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 12.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Discard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'The changes will not be saved. Do you want to discard?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ToolFlowColor.coolGery,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: CupertinoColors.separator),

              // -------- bottom buttons (Cancel | Discard) ----------
              SizedBox(
                height: 48.h,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // user cancel করল → false
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, color: CupertinoColors.separator),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          // user discard করল → true
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Discard',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
