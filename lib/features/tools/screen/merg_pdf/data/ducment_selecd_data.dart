import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_scanner/features/tools/widget/custom_document_list.dart';

/// multiple selection state
final documentSelectionProvider =
    StateNotifierProvider.autoDispose<DocumentSelectionNotifier, Set<int>>(
      (ref) => DocumentSelectionNotifier(),
    );
