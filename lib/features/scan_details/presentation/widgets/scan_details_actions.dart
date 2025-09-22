import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/providers/scan_history_provider.dart';
import 'package:visionscan_pro/features/scan_details/domain/usecases/copy_scan_data_usecase.dart';
import 'package:visionscan_pro/features/scan_details/domain/usecases/export_scan_usecase.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/snackbar_helper.dart';

/// Actions widget for scan details page
class ScanDetailsActions extends ConsumerWidget {
  const ScanDetailsActions({required this.scan, super.key});

  final ScanResult scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space24),
      decoration: NeumorphicDecoration.softCard(color: AppTheme.primaryWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),

          const SizedBox(height: AppTheme.space16),

          // Export options
          _buildExportSection(context, ref),

          const SizedBox(height: AppTheme.space16),

          // Copy and Share buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => _copyAllNumbers(context, ref),
                  variant: AppButtonVariant.secondary,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIconsRegular.copy, size: 18),
                      SizedBox(width: AppTheme.space8),
                      Text('Copy All'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.space12),
              Expanded(
                child: AppButton(
                  onPressed: () => _shareScan(context, ref),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsRegular.share,
                        size: 18,
                        color: AppTheme.primaryWhite,
                      ),
                      SizedBox(width: AppTheme.space8),
                      Text('Share'),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space16),

          // Delete button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () => _showDeleteDialog(context, ref),
              variant: AppButtonVariant.outline,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsRegular.trash, size: 18),
                  SizedBox(width: AppTheme.space8),
                  Text('Delete Scan'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => _exportAsCsv(context, ref),
                variant: AppButtonVariant.secondary,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(PhosphorIconsRegular.fileCsv, size: 18),
                    SizedBox(width: AppTheme.space8),
                    Text('Export CSV'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Expanded(
              child: AppButton(
                onPressed: () => _exportAsPdf(context, ref),
                variant: AppButtonVariant.secondary,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(PhosphorIconsRegular.filePdf, size: 18),
                    SizedBox(width: AppTheme.space8),
                    Text('Export PDF'),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.space12),

        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () => _exportAsJson(context, ref),
            variant: AppButtonVariant.secondary,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(PhosphorIconsRegular.code, size: 18),
                SizedBox(width: AppTheme.space8),
                Text('Export JSON'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _exportAsCsv(BuildContext context, WidgetRef ref) async {
    try {
      AppLogger.info('Starting CSV export for scan: ${scan.id}');
      final file = await ref
          .read(exportScanUseCaseProvider.notifier)
          .exportAsCsv(scan);
      AppLogger.info('CSV export completed. File saved to: ${file.path}');
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, 'CSV file exported successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('CSV export error: $e', stackTrace: stackTrace);
      AppLogger.error('Stack trace: $stackTrace');
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to export CSV: $e');
      }
    }
  }

  Future<void> _exportAsPdf(BuildContext context, WidgetRef ref) async {
    try {
      AppLogger.info('Starting PDF export for scan: ${scan.id}');
      final file = await ref
          .read(exportScanUseCaseProvider.notifier)
          .exportAsPdf(scan);
      AppLogger.info('PDF export completed. File saved to: ${file.path}');
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, 'PDF file exported successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('PDF export error: $e', stackTrace: stackTrace);
      AppLogger.error('Stack trace: $stackTrace');
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to export PDF: $e');
      }
    }
  }

  Future<void> _exportAsJson(BuildContext context, WidgetRef ref) async {
    try {
      AppLogger.info('Starting JSON export for scan: ${scan.id}');
      final file = await ref
          .read(exportScanUseCaseProvider.notifier)
          .exportAsJson(scan);
      AppLogger.info('JSON export completed. File saved to: ${file.path}');
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, 'JSON file exported successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('JSON export error: $e', stackTrace: stackTrace);
      AppLogger.error('Stack trace: $stackTrace');
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to export JSON: $e');
      }
    }
  }

  Future<void> _copyAllNumbers(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(copyScanDataUseCaseProvider.notifier)
          .copyAllNumbers(scan.extractedNumbers);
      if (context.mounted) {
        SnackbarHelper.showCopySuccess(
          context,
          'All numbers copied to clipboard',
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to copy numbers: $e');
      }
    }
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Scan'),
        content: const Text(
          'Are you sure you want to delete this scan? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteScan(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteScan(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(scanHistoryProvider.notifier).deleteScan(scan.id);
      // Navigate back after successful deletion
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, 'Failed to delete scan: $e');
      }
    }
  }
}
