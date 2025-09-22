import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Empty state widget for history page
class HistoryEmptyState extends StatelessWidget {
  const HistoryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray100,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: const Icon(
                PhosphorIconsRegular.clock,
                size: 64,
                color: AppTheme.neutralGray400,
              ),
            ),

            const SizedBox(height: AppTheme.space24),

            Text(
              'No Scans Yet',
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),

            const SizedBox(height: AppTheme.space12),

            Text(
              'Start scanning documents to see your history here.\nTap the camera button to begin.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.neutralGray500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.space32),

            AppButton(
              onPressed: () => _navigateToCamera(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(PhosphorIconsRegular.camera, size: 20),
                  SizedBox(width: AppTheme.space8),
                  Text('Start Scanning'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCamera(BuildContext context) {
    context.go('/camera');
  }
}
