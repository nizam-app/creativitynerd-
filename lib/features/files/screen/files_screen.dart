import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf_scanner/core/constants/color_control/all_color.dart';
import '../../onbording/widget/CustomButton.dart';
import '../widget/personal_document.dart';

/// Sort enums
enum SortField { name, size, date }
enum SortOrder { asc, desc }

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});
  static const String routeName = '/files';

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

enum _Tab { files, folders, favorites }

class _FilesScreenState extends State<FilesScreen> {
  _Tab _tab = _Tab.files;

  // sort state
  SortField _sortField = SortField.name;
  SortOrder _sortOrder = SortOrder.asc;

  final List<_FileItem> _files = List.generate(
    6,
        (i) => _FileItem(
      title: '04 Aug, document 1',
      pages: 25,
      sizeKb: 536,
      isStarred: i == 1 || i == 4,
      createdAt: DateTime(2024, 8, 4).add(Duration(days: i)),
    ),
  );

  final List<_FolderItem> _folders = [
    _FolderItem(name: 'Personal Documents', count: 25),
    _FolderItem(name: 'Personal Documents', count: 25),
  ];

  /// apply current sort on _files
  void _applySort() {
    _files.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case SortField.name:
          cmp = a.title.compareTo(b.title);
          break;
        case SortField.size:
          cmp = a.sizeKb.compareTo(b.sizeKb);
          break;
        case SortField.date:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return _sortOrder == SortOrder.asc ? cmp : -cmp;
    });
  }

  /// open the "Sort by" bottom sheet
  void _openSortSheet() {
    showSortByBottomSheet(
      context,
      initialField: _sortField,
      initialOrder: _sortOrder,
      onApply: (field, order) {
        setState(() {
          _sortField = field;
          _sortOrder = order;
          _applySort();
        });
      },
    );
  }

  Widget _buildLeadingActionButton() {
    switch (_tab) {
      case _Tab.files:
        return _TinySquareButton.svg(
          asset: 'assets/images/filder.svg',
          onTap: (){},
        );

      case _Tab.folders:
        return _TinySquareButton.svg(
          asset: 'assets/images/new_folder.svg',
          onTap: _showCreateFolderDialog,
        );

      case _Tab.favorites:
        return _TinySquareButton.svg(
          asset: 'assets/images/filder.svg', // chaile same file icon o dite paro
          onTap: (){},
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF6F8FC);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [

                  _buildLeadingActionButton(),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _SegmentedTabs(
                      current: _tab,
                      onChanged: (t) => setState(() => _tab = t),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _TinySquareButton.icon(
                    icon: CupertinoIcons.search,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              // Promo banner
              const _DealsBanner(),
              SizedBox(height: 14.h),
              // Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: switch (_tab) {
                    _Tab.files => _FilesList(
                      files: _files,
                      onMore: _onFileMore,
                      onToggleStar: (i) => setState(() {
                        _files[i] = _files[i].copyWith(
                          isStarred: !_files[i].isStarred,
                        );
                      }),
                    ),
                    _Tab.folders => _FoldersList(
                      folders: _folders,
                      onMore: _onFolderMore,
                    ),
                    _Tab.favorites => _FilesList(
                      files: _files
                          .asMap()
                          .entries
                          .where((e) => e.value.isStarred)
                          .map((e) => e.value)
                          .toList(),
                      onMore: _onFileMore,
                      onToggleStar: (_) {},
                      readOnlyStar: true,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFileMore(_FileItem f) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: AllColor.gery, // light grey like screenshot
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // === Top file info card ===
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AllColor.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        // thumbnail
                        Container(
                          width: 58.w,
                          height: 58.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(
                              width: 1.w,
                              color: AllColor.gery,
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/books.png',
                            width: 58.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.title,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "sf_Pro",
                                  color: AllColor.black,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${f.sizeKb} KB',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "sf_Pro",
                                  color: AllColor.gery100.withOpacity(0.60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // === Group 1: Rename / Move / Edit / Delete ===
                _buildActionGroup([
                  const _SheetActionTile(
                    icon: Icons.drive_file_rename_outline,
                    label: 'Rename',
                    iconColor: AllColor.iconColor,
                    textColor: AllColor.black,
                    onTap: null,
                  ),
                  const _SheetActionTile(
                    icon: Icons.drive_file_move,
                    label: 'Move to',
                    iconColor: AllColor.iconColor,
                    textColor: AllColor.black,
                    onTap: null,
                  ),
                  const _SheetActionTile(
                    icon: Icons.drive_file_rename_outline,
                    label: 'Edit',
                    iconColor: AllColor.iconColor,
                    textColor: AllColor.black,
                    onTap: null,
                  ),
                  _SheetActionTile(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () async {
                      final res = await showDeleteAlert(context);
                      if (res == null) return;
                      if (res.confirmed) {
                        // delete logic
                        if (res.neverAskAgain) {
                          // save preference
                        }
                      }
                    },
                  ),
                ]),

                // === Group 2: Remove from favorites ===
                _buildActionGroup(const [
                  _SheetActionTile(
                    icon: Icons.star,
                    label: 'Remove from favorites',
                    iconColor: AllColor.starColor,
                    textColor: AllColor.black,
                    onTap: null,
                  ),
                ]),

                // === Group 3: Show info (opens Sort sheet) ===
                _buildActionGroup([
                  _SheetActionTile(
                    icon: Icons.info_outline,
                    label: 'Show info',
                    iconColor: AllColor.iconColor,
                    textColor: AllColor.black,
                    onTap: () {
                      Navigator.of(context).pop();
                      _openSortSheet();
                    },
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  /// One rounded white group with thin dividers between rows
  Widget _buildActionGroup(List<_SheetActionTile> tiles) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AllColor.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            if (i != 0)
              Divider(
                height: 1,
                thickness: 0.4,
                color: AllColor.gery100,
              ),
            tiles[i],
          ],
        ],
      ),
    );
  }

  void _onFolderMore(_FolderItem f) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AllColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetActionTile(
                icon: Icons.drive_file_rename_outline,
                label: 'Edit',
                iconColor: AllColor.iconColor,
                textColor: AllColor.black,
                onTap: null,
              ),
              _SheetActionTile(
                icon: Icons.delete_outline,
                label: 'Delete',
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () async {
                  final res = await showDeleteAlert(context);
                  if (res == null) return;
                  if (res.confirmed) {
                    if (res.neverAskAgain) {
                      // save preference
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreateFolderDialog() async {
    final controller = TextEditingController();
    final created = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _CreateFolderDialog(controller: controller),
    );
    if (created != null && created.trim().isNotEmpty) {
      setState(() {
        _folders.insert(
          0,
          _FolderItem(name: created.trim(), count: 0),
        );
        _tab = _Tab.folders;
      });
    }
  }
}


class _TinySquareButton extends StatelessWidget {
  const _TinySquareButton({
    required this.child,
    required this.onTap,
  });

  /// Normal icon (Material IconData)
  _TinySquareButton.icon({
    required IconData icon,
    required this.onTap,
    Color? color,
  }) : child = Icon(
    icon,
    size: 18,
    color: color ?? AllColor.black,
  );

  /// SVG asset ব্যবহার করার জন্য
  _TinySquareButton.svg({
    required String asset,
    required this.onTap,
    Color? color,
  }) : child = SvgPicture.asset(
    asset,
    height: 24.h,
    width: 24.w,
    colorFilter: color != null
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null,
  );

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: child,
        ),
      ),
    );
  }
}

/// ───────────────── Segmented Tabs ─────────────────
class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.current, required this.onChanged});
  final _Tab current;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    final bg = AllColor.gery;
    final pill = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AllColor.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Row(
          children: [
            _seg('Files', current == _Tab.files, () => onChanged(_Tab.files)),
            _seg('Folders', current == _Tab.folders, () => onChanged(_Tab.folders)),
            _seg('Favorites', current == _Tab.favorites, () => onChanged(_Tab.favorites)),
          ],
        ),
      ),
    );
    return pill;
  }

  Widget _seg(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFEFF3FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AllColor.black,
              fontFamily: "sf_Pro",
            ),
          ),
        ),
      ),
    );
  }
}

/// ───────────────── Promo Banner ─────────────────
class _DealsBanner extends StatelessWidget {
  const _DealsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE4FFD7), Color(0xFFEAF1FF)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/images/giftbox.svg',
              width: 28.w,
              height: 28.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Year Deals!',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "sf_Pro",
                      color: AllColor.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '20% OFF',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AllColor.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: "sf_Pro",
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 38.h,
                width: 106.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: AllColor.primary,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(width: 1.w, color: AllColor.primary),
                ),
                child: Center(
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: "sf_Pro",
                      color: AllColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ───────────────── Files List ─────────────────
class _FilesList extends StatelessWidget {
  const _FilesList({
    required this.files,
    required this.onMore,
    required this.onToggleStar,
    this.readOnlyStar = false,
  });

  final List<_FileItem> files;
  final void Function(_FileItem) onMore;
  final ValueChanged<int> onToggleStar;
  final bool readOnlyStar;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const _Empty();
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 12.h),
      itemBuilder: (_, i) {
        final f = files[i];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AllColor.black.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Thumb
                  Container(
                    width: 58.w,
                    height: 58.h,
                    decoration: BoxDecoration(
                      color: AllColor.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        width: 2.w,
                        color: AllColor.gery,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: Image.asset(
                        'assets/images/books.png',
                        width: 58.w,
                        height: 58.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AllColor.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "sf_Pro",
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${f.pages} pages  •  ${f.sizeKb} KB',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AllColor.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "sf_Pro",
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Star
                  InkWell(
                    onTap: readOnlyStar ? null : () => onToggleStar(i),
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        f.isStarred
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        color: f.isStarred
                            ? AllColor.starColor
                            : AllColor.black,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  // More
                  InkWell(
                    onTap: () => onMore(f),
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.more_horiz,
                        color: AllColor.iconColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: files.length,
    );
  }
}

/// ───────────────── Folders List ─────────────────
class _FoldersList extends StatelessWidget {
  const _FoldersList({required this.folders, required this.onMore});
  final List<_FolderItem> folders;
  final void Function(_FolderItem) onMore;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const _Empty();
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 12.h),
      itemBuilder: (_, i) {
        final f = folders[i];
        return Material(
          color: AllColor.white,
          borderRadius: BorderRadius.circular(14.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () {
              context.go(PersonalDocumentsScreen.routeName);
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AllColor.black.withOpacity(.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Folder icon
                  SvgPicture.asset(
                    'assets/images/folder.svg',
                    width: 36.w,
                    height: 36.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "sf_Pro",
                            color: AllColor.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${f.count} documents',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "sf_Pro",
                            color: AllColor.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => onMore(f),
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.more_horiz,
                        color: AllColor.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemCount: folders.length,
    );
  }
}

/// ───────────────── Empty Placeholder ─────────────────
class _Empty extends StatelessWidget {
  const _Empty();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No items',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black45,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// ───────────────── Create Folder Dialog ─────────────────

class _CreateFolderDialog extends StatelessWidget {
  const _CreateFolderDialog({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'Create new folder',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "sf_Pro",
            color: AllColor.black,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter the folder name below',
            style: TextStyle(
              fontSize: 13.sp,
              color: AllColor.black.withOpacity(0.6),  // Slight opacity for the subtitle
              fontFamily: "sf_Pro",
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            style: TextStyle(
              fontSize: 16.sp,
              color: AllColor.black,
              fontFamily: "sf_Pro",
              fontWeight: FontWeight.w400,
            ),
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter Name',
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: AllColor.black.withOpacity(0.6),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AllColor.gery100.withOpacity(0.10), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AllColor.gery100.withOpacity(0.10), width: 1.w),
              ),
            ),
          ),

            // Add vertical space before divider
            Divider(
              color: AllColor.gery,  // Color of the divider
              thickness: 1.w,  // Set thickness of the divider
              indent: 10.w,  // Indentation on the left side
              endIndent: 10.w,  // Indentation on the right side

          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: AllColor.primary,
                    fontFamily: "sf_Pro",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Container(
                height: 70.h,
                width: 1.w,
                color: AllColor.gery,
              ),

              // Create Button
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: AllColor.primary,
                    fontFamily: "sf_Pro",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )

        ],

      ),



      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),  // Rounded corners for the dialog
      ),
      backgroundColor: Colors.white,  // Set the background to white
    );
  }
}
/// ───────────────── Data Models ─────────────────
class _FileItem {
  final String title;
  final int pages;
  final int sizeKb;
  final bool isStarred;
  final DateTime createdAt;

  _FileItem({
    required this.title,
    required this.pages,
    required this.sizeKb,
    this.isStarred = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  _FileItem copyWith({
    String? title,
    int? pages,
    int? sizeKb,
    bool? isStarred,
    DateTime? createdAt,
  }) {
    return _FileItem(
      title: title ?? this.title,
      pages: pages ?? this.pages,
      sizeKb: sizeKb ?? this.sizeKb,
      isStarred: isStarred ?? this.isStarred,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class _FolderItem {
  final String name;
  final int count;
  _FolderItem({required this.name, required this.count});
}

class DeleteDialogResult {
  final bool confirmed;
  final bool neverAskAgain;
  const DeleteDialogResult({
    required this.confirmed,
    required this.neverAskAgain,
  });
}

/// Call: final res = await showDeleteAlert(context);
Future<DeleteDialogResult?> showDeleteAlert(BuildContext context) async {
  bool neverAsk = false;

  return showCupertinoDialog<DeleteDialogResult>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) => CupertinoAlertDialog(
          title: Text(
            'Delete Alert!',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "sf_Pro",
              color: AllColor.black,
            ),
          ),
          content: Column(
            children: [
              const SizedBox(height: 6),
              Text(
                'Are you sure you want to delete this file?',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "sf_Pro",
                  color: AllColor.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CupertinoCheckbox(
                    value: neverAsk,
                    onChanged: (v) =>
                        setState(() => neverAsk = v ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'Never ask me again',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "sf_Pro",
                        color: AllColor.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(
                DeleteDialogResult(
                  confirmed: false,
                  neverAskAgain: neverAsk,
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "sf_Pro",
                  color: AllColor.primary,
                ),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(ctx).pop(
                DeleteDialogResult(
                  confirmed: true,
                  neverAskAgain: neverAsk,
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "sf_Pro",
                  color: AllColor.primary,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Single row (icon + label) for file/folder actions
class _SheetActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onTap;

  const _SheetActionTile({
    Key? key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.textColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "sf_Pro",
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------- SORT BY BOTTOM SHEET -----------------


Future<void> showSortByBottomSheet(
    BuildContext context, {
      required SortField initialField,
      required SortOrder initialOrder,
      required void Function(SortField field, SortOrder order) onApply,
    }) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AllColor.gery,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
    ),
    builder: (ctx) {
      SortField selectedField = initialField;
      SortOrder selectedOrder = initialOrder;

      return StatefulBuilder(
        builder: (ctx, setState) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Sort by',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "sf_Pro",
                            color: AllColor.black,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Padding(
                          padding: EdgeInsets.all(4.r),
                          child: Icon(
                            Icons.close,
                            size: 20.sp,
                            color: AllColor.gery100,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: AllColor.gery100,
                  ),
                  SizedBox(height: 16.h),

                  // Group 1: sort field
                  _SortCard(
                    children: [
                      _SortRow(
                        title: 'Sort by name',
                        selected: selectedField == SortField.name,
                        trailing: _TrailingLabel(
                          selected: selectedField == SortField.name,
                          isVertical: false,
                          icon: 'assets/images/add_text.svg',  // Add icon path
                        ),
                        onTap: () {
                          setState(() => selectedField = SortField.name);
                        },
                      ),
                      const _SortDivider(),
                      _SortRow(
                        title: 'Sort by size',
                        selected: selectedField == SortField.size,
                        trailing: _TrailingLabel(
                          selected: selectedField == SortField.size,
                          isVertical: false,
                          icon: 'assets/images/size_icon.svg',  // Add icon path
                        ),
                        onTap: () {
                          setState(() => selectedField = SortField.size);
                        },
                      ),
                      const _SortDivider(),
                      _SortRow(
                        title: 'Sort by date',
                        selected: selectedField == SortField.date,
                        trailing: _TrailingLabel(
                          selected: selectedField == SortField.date,
                          isVertical: false,
                          icon: 'assets/images/date_icon.svg',  // Add icon path
                        ),
                        onTap: () {
                          setState(() => selectedField = SortField.date);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Group 2: sort order
                  _SortCard(
                    children: [
                      _SortRow(
                        title: 'Ascending',
                        selected: selectedOrder == SortOrder.asc,
                        trailing: _TrailingLabel(
                          isVertical: true,
                          selected: selectedOrder == SortOrder.asc,
                          icon: 'assets/images/ascendigIcon.svg',  // Add icon path
                        ),
                        onTap: () {
                          setState(() => selectedOrder = SortOrder.asc);
                        },
                      ),
                      const _SortDivider(),
                      _SortRow(
                        title: 'Descending',
                        selected: selectedOrder == SortOrder.desc,
                        trailing: _TrailingLabel(
                          isVertical: true,
                          selected: selectedOrder == SortOrder.desc,
                          icon: 'assets/images/descending_icon.svg',  // Add icon path
                        ),
                        onTap: () {
                          setState(() => selectedOrder = SortOrder.desc);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Apply button
                  CustomButton(
                    text: "Apply",
                    onPressed: () {
                      onApply(selectedField, selectedOrder);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// Sort card with its children widgets
class _SortCard extends StatelessWidget {
  final List<Widget> children;
  const _SortCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AllColor.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// Sort row with title, selected state, and trailing (icons)
class _SortRow extends StatelessWidget {
  final String title;
  final bool selected;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SortRow({
    required this.title,
    required this.selected,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AllColor.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 10.h,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28.w,
              child: selected
                  ? Icon(Icons.check, color: primary, size: 20.sp)
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "sf_Pro",
                  color: selected ? primary : AllColor.black,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// Divider widget for separating each row
class _SortDivider extends StatelessWidget {
  const _SortDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.4,
      color: AllColor.gery100,
    );
  }
}

// Trailing label with icon for sort options
class _TrailingLabel extends StatelessWidget {
  final bool selected;
  final bool isVertical;
  final String icon; // Added icon parameter

  const _TrailingLabel({
    required this.selected,
    this.isVertical = false,
    required this.icon,  // Receive icon path as a parameter
  });

  @override
  Widget build(BuildContext context) {
    final primary = AllColor.primary;

    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isVertical ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // First SVG Icon (using the icon passed as a parameter)
          SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.w,
            colorFilter: ColorFilter.mode(
              selected ? primary : AllColor.black,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
