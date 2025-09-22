import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/scan_details/domain/usecases/export_scan_usecase.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/snackbar_helper.dart';

/// Header widget for scan details page
class ScanDetailsHeader extends ConsumerWidget implements PreferredSizeWidget {
  const ScanDetailsHeader({required this.scan, super.key});

  final ScanResult scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppTheme.primaryWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: AppIconButton(
        icon: PhosphorIconsRegular.caretLeft,
        size: 44,
        variant: AppIconButtonVariant.ghost,
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Scan Details',
        style: AppTheme.headlineMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryBlack,
        ),
      ),
      centerTitle: false,
      actions: [
        AppIconButton(
          icon: PhosphorIconsRegular.share,
          size: 44,
          variant: AppIconButtonVariant.ghost,
          onPressed: () => _shareScan(context, ref),
        ),
        const SizedBox(width: AppTheme.space8),
      ],
    );
  }

  Future<void> _shareScan(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(exportScanUseCaseProvider.notifier).shareScanResult(scan);
      if (context.mounted) {
        SnackbarHelper.showShareSuccess(context, 'Scan shared successfully');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to share scan: $e');
      }
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
