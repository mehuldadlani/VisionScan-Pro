import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// A beautiful card widget for displaying scan results with premium design
class ScanResultCard extends StatelessWidget {
  const ScanResultCard({
    required this.scanResult,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showSelection = false,
    super.key,
  });

  final ScanResult scanResult;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space8,
      ),
      child: AppCard(
        elevated: true,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.space12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.neutralGray100, AppTheme.neutralGray50],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.scan,
                    color: AppTheme.primaryBlack,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan #${scanResult.id.substring(0, 8)}',
                        style: AppTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text(
                        _formatDate(scanResult.timestamp),
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.neutralGray600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSelection)
                  _buildSelectionIndicator()
                else
                  AppIconButton(
                    icon: PhosphorIconsRegular.dotsThreeVertical,
                    size: 32,
                    variant: AppIconButtonVariant.ghost,
                    onPressed: onLongPress,
                  ),
              ],
            ),

            const SizedBox(height: AppTheme.space16),

            // Image preview
            _buildImagePreview(),

            const SizedBox(height: AppTheme.space16),

            // Numbers preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.space16),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray50,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.neutralGray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        PhosphorIconsRegular.numberCircleTwo,
                        color: AppTheme.neutralGray600,
                        size: 16,
                      ),
                      const SizedBox(width: AppTheme.space8),
                      Text(
                        'Extracted Numbers (${scanResult.extractedNumbers.length})',
                        style: AppTheme.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space12),
                  if (scanResult.extractedNumbers.isNotEmpty) ...[
                    Wrap(
                      spacing: AppTheme.space8,
                      runSpacing: AppTheme.space8,
                      children: scanResult.extractedNumbers.take(5).map((
                        number,
                      ) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space12,
                            vertical: AppTheme.space8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryWhite,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSmall,
                            ),
                            border: Border.all(color: AppTheme.neutralGray300),
                          ),
                          child: Text(
                            number,
                            style: AppTheme.labelMedium.copyWith(
                              color: AppTheme.primaryBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    if (scanResult.extractedNumbers.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: AppTheme.space8),
                        child: Text(
                          '+${scanResult.extractedNumbers.length - 5} more',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.neutralGray500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppTheme.space16),
                      decoration: BoxDecoration(
                        color: AppTheme.neutralGray100,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusSmall,
                        ),
                        border: Border.all(color: AppTheme.neutralGray200),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            PhosphorIconsRegular.numberCircleTwo,
                            size: 24,
                            color: AppTheme.neutralGray400,
                          ),
                          const SizedBox(height: AppTheme.space8),
                          Text(
                            'No numbers extracted',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.neutralGray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space16),

            // Actions and stats
            Row(
              children: [
                // Confidence indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space12,
                    vertical: AppTheme.space8,
                  ),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    border: Border.all(
                      color: _getConfidenceColor().withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsRegular.brain,
                        size: 16,
                        color: _getConfidenceColor(),
                      ),
                      const SizedBox(width: AppTheme.space4),
                      Text(
                        scanResult.confidencePercentage,
                        style: AppTheme.bodySmall.copyWith(
                          color: _getConfidenceColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Source indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space12,
                    vertical: AppTheme.space8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.neutralGray100,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        scanResult.isFromGallery
                            ? PhosphorIconsRegular.image
                            : PhosphorIconsRegular.camera,
                        size: 14,
                        color: AppTheme.neutralGray600,
                      ),
                      const SizedBox(width: AppTheme.space4),
                      Text(
                        scanResult.isFromGallery ? 'Gallery' : 'Camera',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.neutralGray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.neutralGray200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: scanResult.imagePath?.isNotEmpty ?? false
            ? Image.file(
                File(scanResult.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.neutralGray100, AppTheme.neutralGray50],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.image,
              size: 32,
              color: AppTheme.neutralGray400,
            ),
            SizedBox(height: AppTheme.space8),
            Text(
              'No preview available',
              style: TextStyle(color: AppTheme.neutralGray500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppTheme.primaryBlack : Colors.transparent,
        border: Border.all(
          color: isSelected ? AppTheme.primaryBlack : AppTheme.neutralGray400,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(
              PhosphorIconsRegular.check,
              color: AppTheme.primaryWhite,
              size: 16,
            )
          : null,
    );
  }

  Color _getConfidenceColor() {
    if (scanResult.confidence >= 0.8) {
      return Colors.green;
    } else if (scanResult.confidence >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
