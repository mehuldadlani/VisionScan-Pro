import 'package:flutter/material.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Metadata section widget for scan details with beautiful design
class ScanMetadataSection extends StatelessWidget {
  const ScanMetadataSection({required this.scan, super.key});

  final ScanResult scan;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scan Information',
            style: AppTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlack,
            ),
          ),

          const SizedBox(height: AppTheme.space16),

          _buildMetadataRow('Scan ID', scan.id.substring(0, 8)),
          _buildMetadataRow('Date', _formatDate(scan.timestamp)),
          _buildMetadataRow('Time', _formatTime(scan.timestamp)),
          _buildMetadataRow(
            'Source',
            scan.isFromGallery ? 'Gallery' : 'Camera',
          ),
          _buildMetadataRow(
            'Processing Time',
            _formatProcessingTime(scan.processingDurationMs),
          ),

          const SizedBox(height: AppTheme.space16),

          // Confidence indicator
          Row(
            children: [
              Text(
                'Confidence: ',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.neutralGray600,
                ),
              ),
              const Spacer(),
              Text(
                scan.confidencePercentage,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space8),
      child: Row(
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.neutralGray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatProcessingTime(int? durationMs) {
    if (durationMs == null) return 'N/A';
    if (durationMs < 1000) return '${durationMs}ms';
    return '${(durationMs / 1000).toStringAsFixed(1)}s';
  }
}
