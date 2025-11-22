import 'package:go_router/go_router.dart';
import 'package:pdf_scanner/features/add/screen/add_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_save_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/crop_screen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/documentPreviewScreen.dart';
import 'package:pdf_scanner/features/camerascanner/screen/edit_filter_screen.dart';
import 'package:pdf_scanner/features/files/screen/files_screen.dart';
import 'package:pdf_scanner/features/home/screen/home_screen.dart';
import 'package:pdf_scanner/features/onbording/screens/onboardingScreen.dart';
import 'package:pdf_scanner/features/settings/seceen/settings_screen.dart';
import 'package:pdf_scanner/features/splash/screen/splash_screen.dart';
import 'package:pdf_scanner/features/tools/screen/Congratulations_screen.dart';
import 'package:pdf_scanner/features/tools/screen/merg_pdf/screen/marge_pdf_45.dart';
import 'package:pdf_scanner/features/tools/screen/tools_screen.dart';
import 'package:pdf_scanner/routes/custom_error_screen.dart';

import '../features/camerascanner/screen/camera_screen.dart';
import '../features/files/widget/personal_document.dart';
import '../features/navbar/screen/navbar.dart';

class AppRouter {
  static final String initial = ToolsScreen.routeName;

  static final GoRouter appRouter = GoRouter(
    initialLocation: initial,
    errorBuilder: (context, state) {
      final String badPath = state.uri.toString();
      return CustomGoErrorPage(
        location: badPath,
        error: state.error,
        onRetry: () => context.go(initial),
        onReport: () {},
      );
    },
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: OnboardingScreen.routeName,
        name: OnboardingScreen.routeName,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: HomeScreen.routeName,
        name: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: FilesScreen.routeName,
        name: FilesScreen.routeName,
        builder: (context, state) => const FilesScreen(),
      ),

      GoRoute(
        path: PersonalDocumentsScreen.routeName,
        name: PersonalDocumentsScreen.routeName,
        builder: (context, state) => const PersonalDocumentsScreen(),
      ),

      GoRoute(
        path: ToolsScreen.routeName,
        name: ToolsScreen.routeName,
        builder: (context, state) => const ToolsScreen(),
      ),

      GoRoute(
        path: CameraScreen.routeName,
        name: CameraScreen.routeName,
        builder: (context, state) => const CameraScreen(),
      ),

      GoRoute(
        path: EditFilterScreen.routeName,
        name: EditFilterScreen.routeName,
        builder: (context, state) => const EditFilterScreen(),
      ),

      GoRoute(
        path: CropScreen.routeName,
        name: CropScreen.routeName,
        builder: (context, state) => const CropScreen(),
      ),
      GoRoute(
        path: CropSaveScreen.routeName,
        name: CropSaveScreen.routeName,
        builder: (context, state) => const CropSaveScreen(),
      ),

      GoRoute(
        path: DocumentPreviewScreen.routeName,
        name: DocumentPreviewScreen.routeName,
        builder: (context, state) => const DocumentPreviewScreen(),
      ),

      GoRoute(
        path: SettingsScreen.routeName,
        name: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),

      GoRoute(
        path: AddScreen.routeName,
        name: AddScreen.routeName,
        builder: (context, state) => const AddScreen(),
      ),

      GoRoute(
        path: BottomNavBar.routeName,
        name: BottomNavBar.routeName,
        builder: (context, state) => BottomNavBar(child: HomeScreen()),
      ),
      GoRoute(
        path: MargePdf45.routeName,
        name: MargePdf45.routeName,
        builder: (context, state) => MargePdf45(isCheckScreenName: state.extra as ScreenName),
      ),
      GoRoute(
        path: CongratulationsScreen.routeName,
        name: CongratulationsScreen.routeName,
        builder: (context, state) => CongratulationsScreen(isCheckScreenName: state.extra as ScreenName),
      ),
    ],
  );
}