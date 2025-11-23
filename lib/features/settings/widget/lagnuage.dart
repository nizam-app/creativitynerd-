
import 'package:flutter/material.dart';

import '../../../core/constants/color_control/all_color.dart';
import '../../../core/constants/color_control/tool_flow_color.dart';
import '../../../core/widget/CustomAppbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flagAsset;

  LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagAsset,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  final LanguageOption selected;

  const LanguageSelectionScreen({
    Key? key,
    required this.selected,
  }) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late LanguageOption _current;

  final List<LanguageOption> _languages = [
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flagAsset: 'assets/images/eng.png',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      nativeName: 'française',
      flagAsset: 'assets/images/french.png',
    ),
    LanguageOption(
      code: 'de',
      name: 'Germany',
      nativeName: 'Deutsch',
      flagAsset: 'assets/images/geramany.png',
    ),
    LanguageOption(
      code: 'au',
      name: 'Australian',
      nativeName: 'English',
      flagAsset: 'assets/images/australian.png',
    ),
    LanguageOption(
      code: 'ru',
      name: 'Russian',
      nativeName: 'Русский',
      flagAsset: 'assets/images/russian.png',
    ),
    LanguageOption(
      code: 'ja',
      name: 'Japanese',
      nativeName: '日本語',
      flagAsset: 'assets/images/japan.png',
    ),
    LanguageOption(
      code: 'zh',
      name: 'Mandarin',
      nativeName: '中文',
      flagAsset: 'assets/images/mandarin.png',
    ),
    LanguageOption(
      code: 'it',
      name: 'Italian',
      nativeName: 'Italiano',
      flagAsset: 'assets/images/italian.png',
    ),
    LanguageOption(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flagAsset: 'assets/images/arabic.png',
    ),
    LanguageOption(
      code: 'ms',
      name: 'Malaysian',
      nativeName: 'Bahasa Melayu',
      flagAsset: 'assets/images/malasian.png',
    ),
    LanguageOption(
      code: 'ur',
      name: 'Urdu',
      nativeName: 'اردو',
      flagAsset: 'assets/images/urdu.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final Color pageBg = AllColor.gery;
    // final bgColor = selected ? const Color(0xFFEAEFFD) : Colors.white;
    return Scaffold(
     // backgroundColor: pageBg,

      backgroundColor:  ToolFlowColor.backGroundColor,
      appBar: CustomAppBar(
        title: "Choose language",
        centerTitle: true,
        actionText: 'Done',
       // onActionTap: () => Navigator.of(context).pop(_current),
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.r)
          ),
          child: Container(
           color:  Color(0xFF000000).withOpacity(0.06),
            child: ListView.separated(
              itemCount: _languages.length,
               //padding: EdgeInsets.only(top: 16.h, left: 16.h, right: 16.h),
              separatorBuilder: (_, __) =>
                  Padding(
                padding:  EdgeInsets.only(left: 65.h),
                child:  Divider(
                  height: 0,
                  thickness: 0.5,
                  color: AllColor.gery,
                  //color: Color(0xFFE5E7EB),
                ),
              ),
              itemBuilder: (context, index) {
                final lang = _languages[index];
                final bool selected = lang.code == _current.code;

                return InkWell(
                  onTap: () => setState(() => _current = lang),
                  child: Container(
                    color: selected
                        ? const Color(0xFFF1F4FF)
                        : Colors.white,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          lang.flagAsset,
                          width: 32.w,
                          height: 32.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        lang.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: "sf_Pro",
                          fontWeight: FontWeight.w500,
                          color: AllColor.black,
                        ),
                      ),
                      subtitle: Text(
                        '(${lang.nativeName})',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: "sf_Pro",
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      trailing: selected
                          ? Icon(
                        Icons.check_rounded,
                        color: AllColor.primary,
                        size: 24.sp,
                      )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),

        ),
      ),
    );
  }
}
