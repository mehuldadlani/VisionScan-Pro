import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:visionscan_pro/core/constants/app_constants.dart';

/// Extension methods for BuildContext to provide convenient access
/// to commonly used functionality throughout the application.
extension ContextExtensions on BuildContext {
  // Theme and Design System Access

  /// Gets the current theme data
  ThemeData get theme => Theme.of(this);

  /// Gets the current color scheme
  ColorScheme get colors => theme.colorScheme;

  /// Gets the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Gets whether the current theme is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Gets whether the current theme is light mode
  bool get isLightMode => theme.brightness == Brightness.light;

  // Screen Dimensions and Layout

  /// Gets the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Gets the screen size
  Size get screenSize => mediaQuery.size;

  /// Gets the screen width
  double get screenWidth => screenSize.width;

  /// Gets the screen height
  double get screenHeight => screenSize.height;

  /// Gets the safe area padding
  EdgeInsets get padding => mediaQuery.padding;

  /// Gets the view insets (keyboard, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Gets the device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Gets whether the device is in landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Gets whether the device is in portrait orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Gets whether the device is considered a tablet (width >= 768dp)
  bool get isTablet => screenWidth >= 768;

  /// Gets whether the device is considered a phone
  bool get isPhone => !isTablet;

  /// Gets whether the device has a small screen (width < 600dp)
  bool get isSmallScreen => screenWidth < 600;

  /// Gets whether the device has a large screen (width >= 1024dp)
  bool get isLargeScreen => screenWidth >= 1024;

  // Navigation

  /// Gets the GoRouter instance
  GoRouter get router => GoRouter.of(this);

  /// Pops the current route
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);

  /// Pops until the specified route predicate is met
  void popUntil(RoutePredicate predicate) =>
      Navigator.of(this).popUntil(predicate);

  /// Pops to the root route
  void popToRoot() => popUntil((route) => route.isFirst);

  /// Checks if the navigator can pop
  bool get canPop => Navigator.of(this).canPop();

  // Focus and Keyboard

  /// Gets the primary focus
  FocusNode get primaryFocus => FocusScope.of(this);

  /// Unfocuses the current focus node
  void unfocus() => primaryFocus.unfocus();

  /// Requests focus for the given node
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  /// Gets whether the keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Gets the keyboard height
  double get keyboardHeight => viewInsets.bottom;

  // Snackbars and Overlays

  /// Shows a snackbar with the given message
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
      ),
    );
  }

  /// Shows an error snackbar
  void showErrorSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 6),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message,
      duration: duration,
      backgroundColor: colors.error,
      textColor: colors.onError,
      action: action,
    );
  }

  /// Shows a success snackbar
  void showSuccessSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    showSnackBar(
      message,
      duration: duration,
      backgroundColor: colors.primary,
      textColor: colors.onPrimary,
      action: action,
    );
  }

  /// Clears all snackbars
  void clearSnackBars() => ScaffoldMessenger.of(this).clearSnackBars();

  // Dialogs

  /// Shows a material dialog
  Future<T?> showMaterialDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      builder: (_) => child,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showMaterialDialog<bool>(
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => pop(false), child: Text(cancelText)),
          ElevatedButton(
            onPressed: () => pop(true),
            style: isDestructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  // Bottom Sheets

  /// Shows a modal bottom sheet
  Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (_) => child,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.bottomSheetBorderRadius),
            ),
          ),
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  // Haptic Feedback

  /// Triggers light haptic feedback
  void lightHaptic() => HapticFeedback.lightImpact();

  /// Triggers medium haptic feedback
  void mediumHaptic() => HapticFeedback.mediumImpact();

  /// Triggers heavy haptic feedback
  void heavyHaptic() => HapticFeedback.heavyImpact();

  /// Triggers selection haptic feedback
  void selectionHaptic() => HapticFeedback.selectionClick();

  /// Triggers vibration pattern
  void vibrate() => HapticFeedback.vibrate();

  // Layout Helpers

  /// Gets padding for the app's standard content areas
  EdgeInsets get contentPadding =>
      const EdgeInsets.all(AppConstants.defaultPadding);

  /// Gets padding for smaller content areas
  EdgeInsets get smallContentPadding =>
      const EdgeInsets.all(AppConstants.smallPadding);

  /// Gets padding for larger content areas
  EdgeInsets get largeContentPadding =>
      const EdgeInsets.all(AppConstants.largePadding);

  /// Gets horizontal padding for content
  EdgeInsets get horizontalPadding =>
      const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding);

  /// Gets vertical padding for content
  EdgeInsets get verticalPadding =>
      const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding);

  /// Gets responsive padding based on screen size
  EdgeInsets get responsivePadding => EdgeInsets.all(
    isTablet ? AppConstants.largePadding : AppConstants.defaultPadding,
  );

  /// Gets responsive horizontal padding
  EdgeInsets get responsiveHorizontalPadding => EdgeInsets.symmetric(
    horizontal: isTablet
        ? AppConstants.largePadding
        : AppConstants.defaultPadding,
  );

  /// Gets responsive vertical padding
  EdgeInsets get responsiveVerticalPadding => EdgeInsets.symmetric(
    vertical: isTablet
        ? AppConstants.largePadding
        : AppConstants.defaultPadding,
  );
}
