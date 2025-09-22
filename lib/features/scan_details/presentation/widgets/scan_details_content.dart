import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/scan_details/presentation/widgets/scan_metadata_section.dart';
import 'package:visionscan_pro/features/scan_details/presentation/widgets/scan_numbers_section.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Content widget for scan details page
class ScanDetailsContent extends StatelessWidget {
  const ScanDetailsContent({required this.scan, super.key});

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image preview section
          _buildImageSection(context),
          const SizedBox(height: AppTheme.space24),
          AppButton(
            onPressed: () => _viewFullImage(context),
            variant: AppButtonVariant.outline,
            size: AppButtonSize.small,
            width: double.infinity,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIconsRegular.frameCorners, size: 16),
                SizedBox(width: AppTheme.space8),
                Text('View Full Size'),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.space24),

          // Metadata section
          ScanMetadataSection(scan: scan),

          const SizedBox(height: AppTheme.space24),

          // Numbers section
          ScanNumbersSection(scan: scan),

          const SizedBox(height: AppTheme.space32),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () => _viewFullImage(context),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: AppTheme.neutralGray200),
          color: AppTheme.neutralGray100,
        ),
        child: scan.imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                child: Image.file(
                  File(scan.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                ),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsRegular.image,
            size: 48,
            color: AppTheme.neutralGray400,
          ),
          const SizedBox(height: AppTheme.space12),
          Text(
            'No image available',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGray500),
          ),
        ],
      ),
    );
  }

  void _viewFullImage(BuildContext context) {
    if (scan.imagePath?.isNotEmpty ?? false) {
      context.push('/image-viewer/${Uri.encodeComponent(scan.imagePath!)}');
    }
  }
}
