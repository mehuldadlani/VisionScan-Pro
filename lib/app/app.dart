import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/navigation/routes/router.dart';
import 'package:visionscan_pro/core/providers/startup/app_startup_provider.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// The main VisionScan Pro application widget
///
/// This widget sets up the application with proper theming,
/// localization, navigation, and error handling.
class VisionScanProApp extends ConsumerWidget {
  /// Creates a VisionScan Pro app
  const VisionScanProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // App Configuration
      title: 'VisionScan Pro',
      debugShowCheckedModeBanner: false,

      // Routing
      routerConfig: router,

      // Premium Theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Builder for handling app startup
      builder: (context, child) {
        return AppStartupWrapper(child: child);
      },
    );
  }
}

/// Wrapper widget that handles application startup sequence
///
/// This widget ensures that critical services are initialized
/// before the main app UI is shown to the user.
class AppStartupWrapper extends ConsumerStatefulWidget {
  /// Creates a app startup wrapper
  const AppStartupWrapper({super.key, this.child});

  /// The child widget
  final Widget? child;

  @override
  ConsumerState<AppStartupWrapper> createState() => _AppStartupWrapperState();
}

class _AppStartupWrapperState extends ConsumerState<AppStartupWrapper> {
  bool _showFallback = false;

  @override
  void initState() {
    super.initState();
    // Show fallback after 15 seconds if startup is still loading
    Timer(const Duration(seconds: 15), () {
      if (mounted && ref.read(appStartupProvider).isLoading) {
        setState(() {
          _showFallback = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final startupState = ref.watch(appStartupProvider);

    return startupState.when(
      data: (result) {
        if (result.isSuccess) {
          // Startup completed successfully, show main app
          return widget.child ?? const SizedBox.shrink();
        } else {
          // Startup failed, show error screen
          return AppStartupErrorScreen(result: result);
        }
      },
      loading: () {
        // Show fallback loading screen if startup takes too long
        if (_showFallback) {
          return const AppStartupFallbackScreen();
        }
        return const AppStartupLoadingScreen();
      },
      error: (error, stackTrace) => AppStartupErrorScreen(
        result: AppStartupResult.failure(error: error, stackTrace: stackTrace),
      ),
    );
  }
}

/// Loading screen shown during app startup
class AppStartupLoadingScreen extends StatelessWidget {
  /// Creates a app startup loading screen
  const AppStartupLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionScan Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.neutralGray50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium app logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryBlack, AppTheme.neutralGray800],
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                  boxShadow: AppTheme.elevatedShadow,
                ),
                child: const Icon(
                  PhosphorIconsRegular.scan,
                  size: 60,
                  color: AppTheme.primaryWhite,
                ),
              ),
              const SizedBox(height: AppTheme.space32),
              // App title
              Text(
                'VisionScan Pro',
                style: AppTheme.displayMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppTheme.space8),
              // Loading text
              Text(
                'Initializing...',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.neutralGray600,
                ),
              ),
              const SizedBox(height: AppTheme.space32),
              // Premium loading indicator
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryWhite,
                  border: Border.all(color: AppTheme.neutralGray200),
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryBlack,
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error screen shown when app startup fails
class AppStartupErrorScreen extends StatelessWidget {
  /// Creates a app startup error screen
  const AppStartupErrorScreen({required this.result, super.key});

  /// The app startup result
  final AppStartupResult result;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionScan Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.neutralGray50,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium error icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryWhite,
                    border: Border.all(color: AppTheme.neutralGray200),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.warning,
                    size: 40,
                    color: AppTheme.primaryBlack,
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                // Error title
                Text(
                  'Startup Failed',
                  style: AppTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.space16),
                // Error message
                Container(
                  padding: const EdgeInsets.all(AppTheme.space20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryWhite,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    border: Border.all(color: AppTheme.neutralGray200),
                  ),
                  child: Text(
                    'VisionScan Pro failed to initialize properly. Please try restarting the app.',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.neutralGray600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppTheme.space32),
                // Premium retry button
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please restart the app manually'),
                        backgroundColor: AppTheme.primaryBlack,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium,
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    PhosphorIconsRegular.arrowClockwise,
                    size: 18,
                  ),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlack,
                    foregroundColor: AppTheme.primaryWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space32,
                      vertical: AppTheme.space16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.space16),
                // Error details (in debug mode)
                if (result.error != null)
                  ExpansionTile(
                    title: const Text('Error Details'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppTheme.space16),
                        child: Text(
                          result.error.toString(),
                          style: AppTheme.bodySmall.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fallback loading screen shown when startup takes too long
class AppStartupFallbackScreen extends StatelessWidget {
  /// Creates a app startup fallback screen
  const AppStartupFallbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VisionScan Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: AppTheme.neutralGray50,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primaryBlack, AppTheme.neutralGray800],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                    boxShadow: AppTheme.elevatedShadow,
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.scan,
                    size: 50,
                    color: AppTheme.primaryWhite,
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                
                // Title
                Text(
                  'VisionScan Pro',
                  style: AppTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.space16),
                
                // Message
                Text(
                  'Starting up...\nThis may take a moment on first launch.',
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppTheme.neutralGray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.space32),
                
                // Simple loading indicator
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBlack,
                    ),
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(height: AppTheme.space16),
                
                // Help text
                Text(
                  'If this screen persists, please restart the app.',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.neutralGray500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
