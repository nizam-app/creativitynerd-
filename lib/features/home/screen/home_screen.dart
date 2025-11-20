import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import 'package:pdf_scanner/features/camerascanner/screen/camera_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home'; // ✅ router-এর সাথে統一

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGrid = false;

  final List<RecentFile> _recentFiles = const [
    RecentFile(title: '04 Aug, document 1', pages: 25, sizeKb: 536),
    RecentFile(title: '04 Aug, document 1', pages: 25, sizeKb: 536),
    RecentFile(title: '04 Aug, document 1', pages: 25, sizeKb: 536),
    RecentFile(title: '04 Aug, document 1', pages: 25, sizeKb: 536),
  ];

  final List<ToolItem> _tools = const [
    ToolItem('Merge PDF', 'assets/images/mergepdf.svg', AllColor.toolsColor1),
    ToolItem('Split PDF',  'assets/images/splitpdf.svg', AllColor.toolsColor2),
    ToolItem('Image to PDF','assets/images/image_pdf.svg', AllColor.toolsColor3),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF6F8FC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
             _TopRow(),
             _TitleSliver(title: 'Library'),
            _SearchAndToggleSliver(
              isGrid: _isGrid,
              onToggle: () => setState(() => _isGrid = !_isGrid),
              onSearch: (v) {},
            ),


            //SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Divider(
                    color: AllColor.gery,  // Optional: Set color for the divider
                    thickness: 0.5,  // Optional: Adjust thickness of the divider
                  ),
                ],
              ),
            ),

            _ToolsSectionSliver(
              tools: _tools,
              onTapTool: (tool) {
                showAddSheet(context);
              },
            ),
            const _SectionHeaderSliver('Recent files'),

            if (_recentFiles.isEmpty)
              const _EmptyStateSliver(
                title: 'Here is empty',
                message: 'Tap the “+” button below to import or\nscan document',
              )
            else
              _RecentFilesSliver(
                files: _recentFiles,
                grid: _isGrid,
                onTap: (f) {},
                onMore: (f) {},
              ),
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _openAddSheet,
      //   backgroundColor: AllColor.gery,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}

/// =============== SLIVERS ===============

class _TopRow extends StatelessWidget {
  const _TopRow();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        child: Row(
          children: [
            const _UpgradePill(),
            const Spacer(),
          Material(
            color: AllColor.gery100.withOpacity(0.10),
            shape: const CircleBorder(),
            elevation: 0,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: (){},
              child: Padding(
                padding: EdgeInsets.all(16.r), 
                child:Icon(Icons.more_horiz, color: AllColor.black, size: 18.sp) ,
              ),
            ),
          ), 
            
          ],
        ),
      ),
    );
  }
}

class _TitleSliver extends StatelessWidget {
  final String title;
  const _TitleSliver({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AllColor.black,
            fontFamily: "sf_Pro",
            fontSize: 34.sp,
            height: 1.1

          ),
        ),
      ),
    );
  }
}

class _SearchAndToggleSliver extends StatelessWidget {
  final bool isGrid;
  final VoidCallback onToggle;
  final ValueChanged<String> onSearch;
  const _SearchAndToggleSliver({
    required this.isGrid,
    required this.onToggle,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        child: Row(
          children: [
            Expanded(child: _SearchField(hint: 'Search', onChanged: onSearch)), // ✅ wired
            SizedBox(width: 8.w),
            _RoundIconButton(
              onTap: onToggle,
              child: isGrid? SvgPicture.asset('assets/images/filder.svg', width: 20.w, height: 20.h, color: AllColor.black,):SvgPicture.asset('assets/images/filder.svg', width: 20.w, height: 20.h, color: AllColor.black,)

              // Icon(
              //   isGrid ? Icons. : Icons.grid_view_rounded, // ✅ proper toggle
              //   size: 18.sp, color: AllColor.black,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolsSectionSliver extends StatelessWidget {
  final List<ToolItem> tools;
  final void Function(ToolItem) onTapTool;
  const _ToolsSectionSliver({required this.tools, required this.onTapTool});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Text(
                  'Tools',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color:AllColor.black.withOpacity(0.60),
                    fontSize: 14.sp,
                    fontFamily: "sf_Pro"
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: AllColor.black.withOpacity(0.60), size: 20.sp, ),
              ],
            ),
          ),
          SizedBox(
            height: 92.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) => _ToolCard(item: tools[i], onTap: () => onTapTool(tools[i])),
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemCount: tools.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeaderSliver extends StatelessWidget {
  final String text;
  const _SectionHeaderSliver(this.text);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: AllColor.black.withOpacity(0.60),
            fontSize: 12.sp,
            fontFamily: "sf_Pro"
          ),
        ),
      ),
    );
  }
}

class _EmptyStateSliver extends StatelessWidget {
  final String title;
  final String message;
  const _EmptyStateSliver({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
             color: AllColor.gery,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    border: Border.all(width: 2, color: AllColor.gery)
                  ),
                  child: Image.asset('assets/images/books.svg', width: 58.w, height: 58.h)),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AllColor.black, fontFamily: "sf_Pro"),
              ),
              SizedBox(height: 6.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: AllColor.black, fontFamily: "sf_Pro"),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentFilesSliver extends StatelessWidget {
  final List<RecentFile> files;
  final bool grid;
  final void Function(RecentFile) onTap;
  final void Function(RecentFile) onMore;
  const _RecentFilesSliver({
    required this.files,
    required this.grid,
    required this.onTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    if (grid) {
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 96,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) => _RecentFileTile.card(
              file: files[index],
              onTap: () => onTap(files[index]),
              onMore: () => onMore(files[index]),
            ),
            childCount: files.length,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, i) {
          final index = i ~/ 2;
          if (i.isOdd) return SizedBox(height: 8.h);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: _RecentFileTile.list(
              file: files[index],
              onTap: () => onTap(files[index]),
              onMore: () => onMore(files[index]),
            ),
          );
        },
        childCount: files.isEmpty ? 0 : files.length * 2 - 1,
      ),
    );
  }
}

/// =============== SMALL UI PARTS ===============

class _UpgradePill extends StatelessWidget {
  const _UpgradePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      decoration: BoxDecoration(
        color: AllColor.orange,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.emoji_events_rounded, size: 14.sp, color: const Color(0xFFFC8E2B)),
          SvgPicture.asset('assets/images/Vector.svg', width: 14.sp, height: 14.sp,color: AllColor.white, ),
          SizedBox(width: 6.w),
          Text(
            'Upgrade',
            style: TextStyle(
              color: AllColor.white,
              fontWeight: FontWeight.w600,
              fontFamily: "sf_Pro",
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _RoundIconButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AllColor.gery100.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AllColor.gery100.withOpacity(0.10))
          ),
          child: child,
        ),


      ),
    );
  }
}



class _SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;

  const _SearchField({required this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: AllColor.black.withOpacity(0.60),
        fontFamily: "sf_Pro",
        fontSize: 17.sp,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 17.sp,
            color: AllColor.black.withOpacity(0.60),
            fontWeight: FontWeight.w400,
            fontFamily: "sf_Pro"),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 30.r), // Padding for proper alignment
          child: Icon(Icons.search, color: AllColor.gery100, size: 20.sp), // Search icon with size
        ),
        filled: true,
        fillColor: AllColor.gery100.withOpacity(0.10),  // Background color of the search bar
        contentPadding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 16.r), // Ensure the text is centered with proper padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AllColor.gery, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AllColor.gery100.withOpacity(0.10), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AllColor.gery100.withOpacity(0.10), width: 1.w),
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final ToolItem item;
  final VoidCallback onTap;

  const _ToolCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Ink(
        width: 114.w,
        decoration: BoxDecoration(
          color: item.tint.withOpacity(0.1),  // Background color with opacity for better visual
          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: item.tint.withOpacity(0.2), // Shadow with the same color tint
          //     blurRadius: 8.r,
          //     offset: const Offset(0, 3), // Shadow offset
          //   ),
          //],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container with background color and icon
                SvgPicture.asset(
                  item.svg,
                  color: Colors.white,  // White icon to contrast with the background
                  width: 70.w,
                  height: 70.h,
                  colorFilter: ColorFilter.mode(item.tint, BlendMode.srcIn), // Apply the same color tint to the icon
                ),
                SizedBox(height: 8.h),
                Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AllColor.toolsColor,
                    fontSize: 12.sp,
                    fontFamily: "gilroy",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _PdfThumb extends StatelessWidget {
  const _PdfThumb();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
           color: AllColor.white,
          borderRadius: BorderRadius.circular(4.r, ),
          border: Border.all(width: 2.w, color: AllColor.gery)
        ),
        child: Image.asset(
          'assets/images/books.png',
          width: 58.w,
          height: 58.h,
          fit: BoxFit.cover,
          //colorFilter: ColorFilter.mode(Colors.black.withOpacity(.8), BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _RecentFileTile extends StatelessWidget {
  final RecentFile file;
  final VoidCallback onTap;
  final VoidCallback onMore;
  final bool cardStyle;
  const _RecentFileTile._({required this.file, required this.onTap, required this.onMore, required this.cardStyle});

  factory _RecentFileTile.list({required RecentFile file, required VoidCallback onTap, required VoidCallback onMore}) =>
      _RecentFileTile._(file: file, onTap: onTap, onMore: onMore, cardStyle: false);

  factory _RecentFileTile.card({required RecentFile file, required VoidCallback onTap, required VoidCallback onMore}) =>
      _RecentFileTile._(file: file, onTap: onTap, onMore: onMore, cardStyle: true);

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        const _PdfThumb(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(file.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: AllColor.black..withOpacity(0.60))),
              SizedBox(height: 6.h),
              Text('${file.pages} pages  •  ${file.sizeKb} KB',
                  style: TextStyle(fontSize: 12.sp, color: AllColor.black.withOpacity(0.60), fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        InkWell(
          onTap: onMore,
          customBorder:  CircleBorder(

          ),
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Icon(Icons.more_horiz, color: AllColor.gery100.withOpacity(0.60), size: 20.sp,),
            //SvgPicture.asset('assets/images/book.svg', width: 18.sp, height: 18.sp, color: AllColor.primary,),
          ),
        ),
      ],
    );

    if (cardStyle) {
      return Material(
        color: AllColor.white,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: row,
          ),
        ),
      );
    }

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: row,
        ),
      ),
    );
  }
}

class RecentFile {
  final String title;
  final int pages;
  final int sizeKb;
  const RecentFile({required this.title, required this.pages, required this.sizeKb});
}

class ToolItem {
  final String label;
  final String svg;
  final Color tint;
  const ToolItem(this.label, this.svg, this.tint);
}



// Call this from your "+" button
void showAddSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    showDragHandle: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            Expanded(
              child: _ActionTile(
                svg: 'assets/images/photos.svg', // 🟡 update your asset paths
                label: 'Import from\nPhotos',
                onTap: () {}, // TODO
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionTile(
                svg: 'assets/images/files.svg',
                label: 'Import from\nfiles',
                onTap: () {},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionTile(
                svg: 'assets/images/camera.svg',
                label: 'Scan\nDocument',
                onTap: () {
                  context.push(CameraScreen.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.svg,
    required this.label,
    this.onTap,
  });

  final String svg;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: AllColor.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AllColor.black.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SvgPicture.asset(
              svg,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AllColor.black,
                height: 1.2,
                fontFamily: "sf_Pro"
              ),
            ),
          ],
        ),
      ),
    );
  }
}
