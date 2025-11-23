import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/tools/screen/tools_screen.dart';

class UpgradePlanScreen extends StatefulWidget {
  const UpgradePlanScreen({super.key});
  static const String routeName = '/pdf_paywall_screen';

  @override
  State<UpgradePlanScreen> createState() => _UpgradePlanScreenState();
}

class _UpgradePlanScreenState extends State<UpgradePlanScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedPlan = 1; // 0 = yearly, 1 = monthly

  final List<String> _titles = const [
    'PDF Editing Tools',
    'Page Organize',
    'Add Signature',
    'OCR Extract',
  ];

  /// phone + toolbar PNG
  final List<String> _heroImages = const [
    'assets/images/tool/Group01.png',
    'assets/images/tool/Group02.png',
    'assets/images/tool/Group03.png',
    'assets/images/tool/Group04.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF2563EB);

    final Size size = MediaQuery.of(context).size;
    final double heroHeight = size.height * 0.55; // hero section height
    // final double heroWidth = size.width * 0.90; // image ~ full width

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/tool/planBackground.png",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 content
          SafeArea(
            child: Column(
              children: [
                // ---------- Close pill ----------
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push(ToolsScreen.routeName);
                        },
                        child: Container(
                          width: 72.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6FA),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF111111),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                /// ---------- main scrollable content ----------
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ---------- HERO SECTION ----------
                        SizedBox(
                          height: heroHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    // slider image
                                    PageView.builder(
                                      controller: _pageController,
                                      itemCount: _heroImages.length,
                                      physics: const BouncingScrollPhysics(),
                                      onPageChanged: (index) {
                                        setState(() => _currentPage = index);
                                      },
                                      itemBuilder: (context, index) {
                                        double leftPadding = 0;
                                        double rightPadding = 0;

                                        // 3rd image -> left theke 10
                                        if (index == 2) {
                                          leftPadding = 40.w;
                                        }

                                        // 4th image -> right theke 10
                                        if (index == 3) {
                                          rightPadding = 40.w;
                                        }

                                        return Align(
                                          alignment: Alignment.topCenter,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: leftPadding,
                                              right: rightPadding,
                                            ),
                                            child: ShaderMask(
                                              shaderCallback: (Rect rect) {
                                                return const LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.black,
                                                    Colors.black,
                                                    Colors.transparent,
                                                  ],
                                                  stops: [0.0, 0.1, 0.9],
                                                ).createShader(rect);
                                              },
                                              blendMode: BlendMode.dstIn,
                                              child: Image.asset(
                                                _heroImages[index],
                                                width: double.infinity,
                                                height: 800.h,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    // নিচের দিকে soft white fade
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: IgnorePointer(
                                        child: Container(
                                          height: 350.h,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.white.withOpacity(
                                                  0.0,
                                                ), // একদম transparent (উপরে)
                                                Colors.white.withOpacity(
                                                  0.3,
                                                ), // মাঝামাঝি হালকা সাদা
                                                Colors.white.withOpacity(
                                                  0.50,
                                                ), // নিচে প্রায় পুরো সাদা
                                              ],
                                              stops: const [
                                                0.0, // gradient start
                                                0.4, // মাঝামাঝি
                                                1.0, // একদম নিচে
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      left: 0,
                                      bottom: 140.h,
                                      child: Text(
                                        _titles[_currentPage],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AllColor.black,
                                        ),
                                      ),
                                    ),

                                    // slider dots
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 125.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          _heroImages.length,
                                          (index) {
                                            final bool isActive =
                                                index == _currentPage;
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 3.w,
                                              ),
                                              width: isActive ? 18.w : 6.w,
                                              height: 6.w,
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? const Color(0xFF111111)
                                                    : const Color(0xFFC4C4CF),
                                                borderRadius:
                                                    BorderRadius.circular(3.r),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    // "Choose Your Plan"
                                    // "Choose Your Plan" section (same as design)
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 95.h,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 24.w,
                                        ), // line gulo edge theke ektu vitore thakbe
                                        child: Row(
                                          children: [
                                            SizedBox(width: 20.w),
                                            Expanded(
                                              child: _planGradientLine(
                                                isLeft: true,
                                                color: blue,
                                              ),
                                            ),
                                            SizedBox(width: 14.w),
                                            Text(
                                              'Choose Your Plan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF111111),
                                              ),
                                            ),
                                            SizedBox(width: 14.w),
                                            Expanded(
                                              child: _planGradientLine(
                                                isLeft: false,
                                                color: blue,
                                              ),
                                            ),
                                            SizedBox(width: 20.w),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // description
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 45.h,
                                      child: Text(
                                        'Free trial for 3 days, then R\$1,600.00/month\n'
                                        'Recurring billing, cancel anytime.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          height: 1.5,
                                          color: Color(0xFF6b6c6d),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildPlanSection(kPlanBlue),

                        SizedBox(height: 24.h),

                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.r),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: kPlanBlue,
                            //     blurRadius: 10,
                            //     offset: const Offset(0, 6),
                            //   ),
                            // ],
                          ),
                          child: SizedBox(
                            height: 52.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPlanBlue,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26.r),
                                ),
                              ),
                              onPressed: () {
                                // TODO: handle continue tap
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CONTINUE',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // ---------- Footer ----------
                        Text(
                          'Terms of Service  |  Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF6B6B7A),
                            decoration: TextDecoration.underline,
                          ),
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Plan section ----------------
  Widget _buildPlanSection(Color blue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildPlanCard(
            index: 0,
            title: '3 days free trial, then',
            price: 'Rs8,600.00/year',
            selected: _selectedPlan == 0,
            blue: blue,
            isPrimary: false,
          ),
          SizedBox(height: 12.h),

          // Monthly (selected)
          _buildPlanCard(
            index: 1,
            title: '3 days free trial, then',
            price: 'Rs1,600.00/month',
            selected: _selectedPlan == 1,
            blue: blue,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required bool selected,
    required Color blue,
    required bool isPrimary,
  }) {
    final bool isSelected = selected;

    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: () {
        setState(() => _selectedPlan = index);
      },
      child: Container(
        width: double.infinity,
        height: 70.h,
        constraints: BoxConstraints(minHeight: 68.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF657DF2).withOpacity(0.20)
              : kPlanGrey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(26.r),
          border: isSelected
              ? Border.all(color: blue, width: 2) // blue outline selected
              : Border.all(color: AllColor.black.withOpacity(0.15), width: 1.5),
        ),
        child: Row(
          children: [
            // radio / check
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? blue : Colors.transparent,
                border: Border.all(
                  color: isSelected ? blue : const Color(0xFFB9BBC4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12.w),

            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: kTextDark,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? blue : kTextDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planGradientLine({required bool isLeft, required Color color}) {
    return Container(
      height: 5.h, // line thickness (design-er moto)

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isLeft
              ? [
                  color.withOpacity(0.12), // far left fade
                  color.withOpacity(0.70), // mid
                  color.withOpacity(0.95), // near text solid
                ]
              : [
                  color.withOpacity(0.95), // near text solid
                  color.withOpacity(0.70), // mid
                  color.withOpacity(0.12), // far right fade
                ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
}

// top-e define kore nao
const Color kPlanBlue = Color(0xFF657DF2);
const Color kPlanGrey = Color(0xFFE8E8ED);
const Color kTextDark = Color(0xFF333333);
