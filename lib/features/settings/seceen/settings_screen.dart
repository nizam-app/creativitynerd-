import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/core/widget/upgrade_plan_card.dart';
import '../widget/lagnuage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _syncCloud = true;

  LanguageOption _selectedLanguage = LanguageOption(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    flagAsset: 'assets/flags/us.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FB), // light grey/blue bg
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                ),
              ),
              SizedBox(height: 20.h),

              /// UPGRADE CARD
              const UpgradePlanCard(),
              SizedBox(height: 24.h),

              /// LANGUAGE
              const _SectionHeader(title: 'LANGUAGE'),
              SettingsTile(
                leading: SvgPicture.asset(
                  'assets/images/language.svg',
                  height: 24.h,
                  width: 24.w,
                ),
                title: 'Language',
                subtitle: _selectedLanguage.name,
                onTap: () async {
                  final result =
                  await Navigator.of(context).push<LanguageOption>(
                    MaterialPageRoute(
                      builder: (_) => LanguageSelectionScreen(
                        selected: _selectedLanguage,
                      ),
                    ),
                  );
                  if (result != null) {
                    setState(() => _selectedLanguage = result);
                  }
                },
              ),

              SizedBox(height: 10.h),

              /// THEME
              const _SectionHeader(title: 'THEME'),
              SettingsTile(
                leading: SvgPicture.asset(
                  'assets/images/appearance.svg',
                  height: 24.h,
                  width: 24.w,
                ),
                title: 'Appearance',
                subtitle: 'Light',
                onTap: () {},
              ),

              SizedBox(height: 10.h),

              /// CLOUD
              const _SectionHeader(title: 'CLOUD'),
              SettingsSwitchTile(
                leading: SvgPicture.asset(
                  'assets/images/cloud.svg',
                  height: 24.h,
                  width: 24.w,
                ),
                title: 'Sync cloud storage',
                value: _syncCloud,
                onChanged: (v) => setState(() => _syncCloud = v),
              ),

              SizedBox(height: 10.h),

              /// GENERAL  (ONE CARD WITH 4 ROWS)
              const _SectionHeader(title: 'GENERAL'),
              _GroupedSettingsCard(
                tiles: [
                  _GroupedSettingsTile(
                    leading: SvgPicture.asset(
                      'assets/images/share.svg',
                      height: 24.h,
                      width: 24.w,
                    ),
                    title: 'Share app',
                    onTap: () {},
                  ),
                  _GroupedSettingsTile(
                    leading: SvgPicture.asset(
                      'assets/images/like.svg',
                      height: 24.h,
                      width: 24.w,
                    ),
                    title: 'Rate us',
                    onTap: () {},
                  ),
                  _GroupedSettingsTile(
                    leading: SvgPicture.asset(
                      'assets/images/privacy.svg',
                      height: 24.h,
                      width: 24.w,
                    ),
                    title: 'Privacy policy',
                    onTap: () {},
                  ),
                  _GroupedSettingsTile(
                    leading: SvgPicture.asset(
                      'assets/images/terms.svg',
                      height: 24.h,
                      width: 24.w,
                    ),
                    title: 'Terms of use',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ───────────────── Helpers ─────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AllColor.black.withOpacity(0.6),
          fontFamily: "sf_Pro",
        ),
      ),
    );
  }
}

/// Single tile card (Language, Theme, etc.)
class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const SettingsTile({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              leading,
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "sf_Pro",
                    color: AllColor.black,
                  ),
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                SizedBox(width: 8.w),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AllColor.black.withOpacity(0.6),
                    fontFamily: "sf_Pro",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: AllColor.black,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Switch tile (Cloud section)
class SettingsSwitchTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            leading,
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                ),
              ),
            ),
            Switch(
              activeColor: Colors.white,
              activeTrackColor: AllColor.primary,
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────────── GENERAL Group Card ─────────────

class _GroupedSettingsCard extends StatelessWidget {
  final List<_GroupedSettingsTile> tiles;

  const _GroupedSettingsCard({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            //if (i != 0)
              // const Divider(
              //   height: 0,
              //   thickness: 0.5,
              //   color: Color(0xFFE5E7EB),
              // ),
            tiles[i],
          ],
        ],
      ),
    );
  }
}

class _GroupedSettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback? onTap;

  const _GroupedSettingsTile({
    Key? key,
    required this.leading,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            leading,
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AllColor.black,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
