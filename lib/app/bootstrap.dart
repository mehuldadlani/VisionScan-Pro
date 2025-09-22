import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bootstrap function that sets up the application environment
/// and handles uncaught errors before launching the app.
///
/// This function should be called from main() to properly initialize
/// the VisionScan Pro application.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Ensure Flutter widgets are initialized first (before zone setup)
  // Note: This may already be called in main.dart to avoid zone mismatch
  try {
    WidgetsBinding.instance;
  } catch (e) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Set up error handling
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  // Set system UI overlay style
  await _configureSystemUI();

  // Configure app-specific settings
  await _configureApp();

  // Setup global cleanup for camera resources
  _setupCameraCleanup();

  // Run the app with proper error boundary
  await runZonedGuarded(
    () async {
      runApp(
        ProviderScope(
          observers: kDebugMode ? [AppProviderObserver()] : [],
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
    },
  );
}

/// Sets up camera resource cleanup for app lifecycle
void _setupCameraCleanup() {
  // Setup global cleanup for camera resources
  AppLifecycleListener(
    onDetach: () async {
      // Add camera cleanup logic here when camera controller is available
      log('App detached - cleaning up camera resources');
    },
    onExitRequested: () async {
      // Cleanup when app is about to exit
      log('App exit requested - cleaning up resources');
      return AppExitResponse.exit;
    },
  );
}

/// Configures system UI overlay style for the application
Future<void> _configureSystemUI() async {
  // Set preferred orientations (portrait only for better UX)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Status bar
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,

      // Navigation bar
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge display
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

/// Configures application-specific settings
Future<void> _configureApp() async {
  // Configure performance settings
  if (!kDebugMode) {
    // Disable debug banners in release mode
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return const ColoredBox(
        color: Colors.red,
        child: Center(
          child: Text(
            'Something went wrong!',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textDirection: TextDirection.ltr,
          ),
        ),
      );
    };
  }
}

/// Provider observer for debugging Riverpod state changes
class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {}

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      log(
        'Provider Failed: ${provider.name ?? provider.runtimeType}\n'
        'Error: $error',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      log('Provider Added: ${provider.name ?? provider.runtimeType} = $value');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      log('Provider Disposed: ${provider.name ?? provider.runtimeType}');
    }
  }
}
