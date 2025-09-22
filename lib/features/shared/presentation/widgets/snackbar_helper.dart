import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Helper class for showing consistent snackbars across the app
class SnackbarHelper {
  /// Show success snackbar with green icon
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      const Icon(
        PhosphorIconsRegular.checkCircle,
        color: Colors.green,
        size: 20,
      ),
    );
  }

  /// Show error snackbar with red warning icon
  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      const Icon(PhosphorIconsRegular.warning, color: Colors.red, size: 20),
    );
  }

  /// Show info snackbar with blue info icon
  static void showInfo(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      const Icon(PhosphorIconsRegular.info, color: Colors.blue, size: 20),
    );
  }

  /// Show copy success snackbar
  static void showCopySuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      const Icon(PhosphorIconsRegular.copy, color: Colors.green, size: 20),
    );
  }

  /// Show share success snackbar
  static void showShareSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      const Icon(PhosphorIconsRegular.share, color: Colors.blue, size: 20),
    );
  }

  /// Private method to show snackbar with consistent styling
  static void _showSnackbar(BuildContext context, String message, Icon icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            icon,
            const SizedBox(width: AppTheme.space8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.primaryBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}
