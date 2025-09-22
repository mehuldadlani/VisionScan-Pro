import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Reusable confidence badge widget
class ConfidenceBadge extends StatelessWidget {
  const ConfidenceBadge({
    required this.confidence,
    this.showIcon = true,
    super.key,
  });

  final double confidence;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space12,
        vertical: AppTheme.space8,
      ),
      decoration: BoxDecoration(
        color: _getConfidenceColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: _getConfidenceColor().withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              PhosphorIconsRegular.brain,
              size: 16,
              color: _getConfidenceColor(),
            ),
            const SizedBox(width: AppTheme.space4),
          ],
          Text(
            '${(confidence * 100).toStringAsFixed(1)}%',
            style: AppTheme.bodySmall.copyWith(
              color: _getConfidenceColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor() {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
