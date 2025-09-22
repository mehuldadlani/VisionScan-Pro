import 'package:flutter/material.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/history_empty_state.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/scan_result_card.dart';

/// List view widget for history page
class HistoryListView extends StatelessWidget {
  const HistoryListView({
    required this.scans,
    required this.onScanTap,
    super.key,
  });

  final List<ScanResult> scans;
  final ValueChanged<ScanResult> onScanTap;

  @override
  Widget build(BuildContext context) {
    if (scans.isEmpty) {
      return const HistoryEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space16,
        vertical: AppTheme.space8,
      ),
      itemCount: scans.length,
      itemBuilder: (context, index) {
        final scan = scans[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.space12),
          child: ScanResultCard(scanResult: scan, onTap: () => onScanTap(scan)),
        );
      },
    );
  }
}
