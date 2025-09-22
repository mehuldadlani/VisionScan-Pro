import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Reusable image preview widget with full-screen viewing capability
class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({
    required this.imagePath,
    this.title = 'Image Preview',
    this.showViewFullSizeButton = true,
    this.maxHeight = 300.0,
    super.key,
  });

  final String imagePath;
  final String title;
  final bool showViewFullSizeButton;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              PhosphorIconsRegular.image,
              color: AppTheme.neutralGray600,
              size: 20,
            ),
            const SizedBox(width: AppTheme.space8),
            Text(
              title,
              style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.space16),

        // Image container
        Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.neutralGray200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: GestureDetector(
              onTap: () => _viewFullImage(context),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImageErrorWidget();
                },
              ),
            ),
          ),
        ),

        if (showViewFullSizeButton) ...[
          const SizedBox(height: AppTheme.space16),
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
        ],
      ],
    );
  }

  Widget _buildImageErrorWidget() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.neutralGray100, AppTheme.neutralGray50],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsRegular.imageBroken,
            size: 48,
            color: AppTheme.neutralGray400,
          ),
          const SizedBox(height: AppTheme.space12),
          Text(
            'Failed to load image',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGray600),
          ),
        ],
      ),
    );
  }

  void _viewFullImage(BuildContext context) {
    if (imagePath.isNotEmpty) {
      context.push('/image-viewer/${Uri.encodeComponent(imagePath)}');
    }
  }
}
