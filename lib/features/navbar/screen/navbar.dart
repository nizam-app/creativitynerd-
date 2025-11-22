import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/add/screen/add_screen.dart';
import 'package:pdf_scanner/features/files/screen/files_screen.dart';
import 'package:pdf_scanner/features/home/screen/home_screen.dart';
import 'package:pdf_scanner/features/settings/seceen/settings_screen.dart';
import 'package:pdf_scanner/features/tools/screen/tools/screen/tools_screen.dart';


final selectedIndex = StateProvider<int>((ref) => 0);

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.child});
  static const String routeName = '/bottomNavBar';


  final Widget child;

  static const _labels = <String>['Home', 'Files', 'Tools', 'Settings'];
  static const _icons  = <IconData>[
    Icons.home_outlined,
    Icons.file_copy_outlined,
    Icons.grid_view_outlined,
    Icons.settings_outlined,
  ];

  static const _pages = <Widget>[
    HomeScreen(),
    FilesScreen(),
    ToolsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(selectedIndex);

    final double fabSize   = 64.r;
    final double fabMargin = 8.w;

    return Scaffold(

      body: IndexedStack(
        index: idx,
        children: _pages,
      ),


      floatingActionButton: _CenterAddButton(
        size: fabSize,
        onTap: () {} //context.push(AddScreen.routeName),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: Material(
          color: AllColor.white,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AllColor.gery, width: 1.5),
            ),
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: 10.h + MediaQuery.of(context).padding.bottom,
              left: 16.w,
              right: 16.w,
            ),
            child: Row(
              children: [
                // Left two
                Expanded(child: _NavItem(
                  label: _labels[0],
                  icon: _icons[0],
                  selected: idx == 0,
                  onTap: () => ref.read(selectedIndex.notifier).state = 0,
                )),
                Expanded(child: _NavItem(
                  label: _labels[1],
                  icon: _icons[1],
                  selected: idx == 1,
                  onTap: () => ref.read(selectedIndex.notifier).state = 1,
                )),

                // center FAB space
                SizedBox(width: fabSize + fabMargin * 2),

                // Right two
                Expanded(child: _NavItem(
                  label: _labels[2],
                  icon: _icons[2],
                  selected: idx == 2,
                  onTap: () => ref.read(selectedIndex.notifier).state = 2,
                )),
                Expanded(child: _NavItem(
                  label: _labels[3],
                  icon: _icons[3],
                  selected: idx == 3,
                  onTap: () => ref.read(selectedIndex.notifier).state = 3,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color active   = AllColor.primary;
    final Color inactive = AllColor.gery;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24.sp, color: selected ? active : inactive),
            SizedBox(height: 4.h),
            SizedBox(
              width: 56.w,
              child: Text(
                label,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: selected ? active : inactive,
                  fontFamily: "sf_Pro"
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  const _CenterAddButton({required this.size, required this.onTap});
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AllColor.primary,
              boxShadow: [
                BoxShadow(
                  color: AllColor.gery.withOpacity(.35),
                  blurRadius: 20, offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.add, color: Colors.white, size: 32.sp),
            ),
          ),
        ),
      ),
    );
  }
}
