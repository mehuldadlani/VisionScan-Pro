import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/scan_details/domain/usecases/copy_scan_data_usecase.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/snackbar_helper.dart';

/// Numbers section widget for scan details
class ScanNumbersSection extends ConsumerWidget {
  const ScanNumbersSection({required this.scan, super.key});

  final ScanResult scan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space24),
      decoration: NeumorphicDecoration.softCard(color: AppTheme.primaryWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Extracted Numbers',
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${scan.extractedNumbers.length} found',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutralGray500,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space16),

          if (scan.extractedNumbers.isEmpty)
            _buildEmptyState()
          else
            _buildNumbersList(context, ref),

          const SizedBox(height: AppTheme.space16),

          // Copy all button
          if (scan.extractedNumbers.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () => _copyAllNumbers(context, ref),
                variant: AppButtonVariant.secondary,

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(PhosphorIconsRegular.copy, size: 18),
                    SizedBox(width: AppTheme.space8),
                    Text('Copy All Numbers'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space32),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray50,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.neutralGray200),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(
              PhosphorIconsRegular.magnifyingGlass,
              size: 48,
              color: AppTheme.neutralGray400,
            ),
            const SizedBox(height: AppTheme.space12),
            Text(
              'No numbers detected',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.neutralGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.space4),
            Text(
              'The image may not contain clear numeric text',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGray500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumbersList(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: AppTheme.space12,
      runSpacing: AppTheme.space12,
      children: scan.extractedNumbers.asMap().entries.map((entry) {
        final index = entry.key;
        final number = entry.value;
        return _buildNumberChip(number, index, context, ref);
      }).toList(),
    );
  }

  Widget _buildNumberChip(
    String number,
    int index,
    BuildContext context,
    WidgetRef ref,
  ) {
    return GestureDetector(
      onTap: () => _copyNumber(number, context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space12,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryWhite, AppTheme.neutralGray50],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.neutralGray300),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlack.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray200,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.space8),
            Text(
              number,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(width: AppTheme.space4),
            const Icon(
              PhosphorIconsRegular.copy,
              size: 16,
              color: AppTheme.neutralGray500,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyNumber(
    String number,
    BuildContext context,
    WidgetRef ref,
  ) async {
    await ref.read(copyScanDataUseCaseProvider.notifier).copyNumber(number);
    if (context.mounted) {
      SnackbarHelper.showCopySuccess(
        context,
        'Number "$number" copied to clipboard',
      );
    }
  }

  Future<void> _copyAllNumbers(BuildContext context, WidgetRef ref) async {
    await ref
        .read(copyScanDataUseCaseProvider.notifier)
        .copyAllNumbers(scan.extractedNumbers);
    if (context.mounted) {
      SnackbarHelper.showCopySuccess(
        context,
        'All ${scan.extractedNumbers.length} numbers copied to clipboard',
      );
    }
  }
}
