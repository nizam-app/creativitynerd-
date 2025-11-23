import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/constants/color_control/tool_flow_color.dart';

class CustomTopBarBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onSearchTap;
  final bool showSearch;
  final IconData icon;

  const CustomTopBarBackButton({
    Key? key,
    required this.title,
    this.onBack,
    this.onSearchTap,
    this.showSearch = true,
    this.icon = Icons.search,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20.h);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: ToolFlowColor.white45,
          border: Border(
            bottom: BorderSide(color: AllColor.black.withOpacity(0.30)),
          ),
        ),
        child: SizedBox(
          height: kToolbarHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Back button – left
              Positioned(
                left: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                ),
              ),

              // Center title
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Search icon – right
              if (showSearch)
                Positioned(
                  right: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      icon,
                      size: 24.sp,
                      color: ToolFlowColor.royal_Blue,
                    ),
                    onPressed: onSearchTap,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
