import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/navigation/widgets/bottom_nav_bar.dart';
import 'package:visionscan_pro/features/camera/presentation/pages/camera_page.dart';
import 'package:visionscan_pro/features/history/presentation/pages/history_page.dart';
import 'package:visionscan_pro/features/image_viewer/presentation/pages/image_viewer_page.dart';
import 'package:visionscan_pro/features/scan_details/presentation/pages/scan_details_page.dart';

part 'generated/router.g.dart';

/// Application router configuration using GoRouter
///
/// Defines all routes and navigation structure for VisionScan Pro
/// following a clean and organized routing pattern.
@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/camera',
    routes: [
      // Bottom navigation shell route
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavigationBar(child: child);
        },
        routes: [
          // Camera route
          GoRoute(
            path: '/camera',
            name: 'camera',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CameraPage()),
          ),

          // History route
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HistoryPage()),
          ),
        ],
      ),

      // Scan details route (outside of shell for full-screen experience)
      GoRoute(
        path: '/scan-details/:scanId',
        name: 'scanDetails',
        builder: (context, state) {
          final scanId = state.pathParameters['scanId']!;
          return ScanDetailsPage(scanId: scanId);
        },
      ),

      // Image viewer route
      GoRoute(
        path: '/image-viewer/:imagePath',
        name: 'imageViewer',
        builder: (context, state) {
          final imagePath = Uri.decodeComponent(
            state.pathParameters['imagePath']!,
          );
          return ImageViewerPage(imagePath: imagePath);
        },
      ),

      // Settings routes (if needed in the future)
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPlaceholderPage(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorPage(error: state.error),

    // Route logging
    debugLogDiagnostics: true,
  );
}

/// Error page for navigation errors
class ErrorPage extends StatelessWidget {
  /// Constructor for ErrorPage
  const ErrorPage({this.error, super.key});

  /// The error to be displayed
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                PhosphorIconsRegular.warning,
                color: Colors.black,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Navigation Error',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  error?.toString() ??
                      'An unexpected navigation error occurred',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/camera'),
              icon: const Icon(PhosphorIconsRegular.camera, size: 18),
              label: const Text('Go to Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder settings page
class SettingsPlaceholderPage extends StatelessWidget {
  /// Constructor for SettingsPlaceholderPage
  const SettingsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIconsRegular.gear,
                color: Colors.grey.shade600,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Settings',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Settings page coming soon',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
