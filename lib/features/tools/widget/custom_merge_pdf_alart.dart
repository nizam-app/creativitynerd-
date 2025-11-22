import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';

Future<String?> showMergePdfNameDialog(
    BuildContext context, {
      required String screenName,      // 'merge' / 'lock'
      String? fileName,               // lock হলে উপরের ছোট টেক্সট
    }) async {
  final controller = TextEditingController();

  final result = await showCupertinoDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _MergePdfNameAlert(
      controller: controller,
      screenName: screenName,
      fileName: fileName,
    ),
  );

  controller.dispose();
  return result; // null == cancel, otherwise text
}


class _MergePdfNameAlert extends StatefulWidget {
  final TextEditingController controller;
  final String screenName;   // 'merge' / 'lock'
  final String? fileName;

  const _MergePdfNameAlert({
    required this.controller,
    required this.screenName,
    this.fileName,
  });

  @override
  State<_MergePdfNameAlert> createState() => _MergePdfNameAlertState();
}

class _MergePdfNameAlertState extends State<_MergePdfNameAlert> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final bool isLock = widget.screenName.toLowerCase() == 'lock' || widget.screenName.toLowerCase() == "unlock";
  

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
                        isLock ? 'Set Password' : 'Merge PDF',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // উপরের ছোট টেক্সট
                    Text(
                      isLock
                          ? (widget.fileName ?? 'PDF File')
                          : 'PDF File Name',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: ToolFlowColor.black,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // TextField (normal / password)
                    CupertinoTextField(
                      controller: widget.controller,
                      obscureText: isLock ? _obscure : false,
                      placeholder:
                      isLock ? 'Enter Password' : 'Enter file name....',
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

                      // শুধু lock মোডে eye icon
                      suffix: isLock
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 6.w),
                          child: Icon(
                            _obscure
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                            size: 18.sp,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      )
                          : null,
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: CupertinoColors.separator),

              // ----- Bottom buttons (Cancel | Ok / Unlock PDF) -----
              SizedBox(
                height: 48.h,
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          // আগের মতোই Cancel flow
                          context.pop(); // dialog বন্ধ
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
                          Navigator.of(context)
                              .pop(widget.controller.text.trim());
                        },
                        child: Text(
                          isLock ? 'Unlock PDF' : 'Ok',
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