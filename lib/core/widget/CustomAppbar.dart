import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final String? actionText;
  final VoidCallback? onActionTap;
  final bool centerTitle;
  final Color backgroundColor;
  final bool showBottomBorder;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.actionText,
    this.onActionTap,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.showBottomBorder = true,

  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              // Back button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AllColor.black,
                  size: 20.sp,
                ),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              ),

              // Title
              Expanded(
                child: centerTitle
                    ? Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "sf_Pro",
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: AllColor.black,
                    ),
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "sf_Pro",
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: AllColor.black,
                    ),
                  ),
                ),
              ),

              // Action text (e.g. Done)
              if (actionText != null)
                TextButton(
                  onPressed: onActionTap,
                  child: Text(
                    actionText!,
                    style: TextStyle(
                      fontFamily: "sf_Pro",
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: AllColor.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
    );
  }
}


//CustomEddit AppBar
class CustomEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final bool showBottomBorder;
  final Color textColor;

  const CustomEditAppBar({
    Key? key,
    required this.title,
    this.onBack,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor = Colors.white,
    this.showBottomBorder = true,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          /// 🔙 Back Button
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 24.sp,
            ),
            onPressed: onBack ?? () => context.pop(),
          ),

          /// 📝 Title
          Expanded(
            child: centerTitle
                ? Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "sf_Pro",
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  color: textColor,
                ),
              ),
            )
                : Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "sf_Pro",
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  color: textColor,
                ),
              ),
            ),
          ),

          /// 🔥 Multi Action Buttons (with very close spacing)
          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!
                  .map(
                    (widget) => Padding(
                  padding: EdgeInsets.only(left: 2.w, ),
                  child: widget,
                ),
              )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
