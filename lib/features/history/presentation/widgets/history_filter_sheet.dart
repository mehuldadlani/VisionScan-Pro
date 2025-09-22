import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/history_filter.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Filter sheet widget for history page
class HistoryFilterSheet extends StatefulWidget {
  const HistoryFilterSheet({
    required this.onFilterApplied,
    required this.onFilterCleared,
    super.key,
  });

  final ValueChanged<HistoryFilter> onFilterApplied;
  final VoidCallback onFilterCleared;

  @override
  State<HistoryFilterSheet> createState() => _HistoryFilterSheetState();
}

class _HistoryFilterSheetState extends State<HistoryFilterSheet> {
  DateTime? _startDate;
  DateTime? _endDate;
  double _minConfidence = 0;
  ScanResultOrderBy _orderBy = ScanResultOrderBy.timestampDesc;
  bool _hasNumbersOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.space20),
      decoration: const BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filter Scans',
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlack,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: widget.onFilterCleared,
                child: const Text('Clear All'),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.space24),

          // Date range filter
          _buildDateRangeFilter(),

          const SizedBox(height: AppTheme.space20),

          // Confidence filter
          _buildConfidenceFilter(),

          const SizedBox(height: AppTheme.space20),

          // Order by filter
          _buildOrderByFilter(),

          const SizedBox(height: AppTheme.space20),

          // Has numbers filter
          _buildHasNumbersFilter(),

          const SizedBox(height: AppTheme.space32),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),

          const SizedBox(height: AppTheme.space64 * 2),
        ],
      ),
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date Range',
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: AppTheme.space12),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Start Date',
                date: _startDate,
                onDateSelected: (date) => setState(() => _startDate = date),
              ),
            ),
            const SizedBox(width: AppTheme.space12),
            Expanded(
              child: _buildDateField(
                label: 'End Date',
                date: _endDate,
                onDateSelected: (date) => setState(() => _endDate = date),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space16,
          vertical: AppTheme.space12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.neutralGray300),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Row(
          children: [
            const Icon(
              PhosphorIconsRegular.calendar,
              size: 16,
              color: AppTheme.neutralGray500,
            ),
            const SizedBox(width: AppTheme.space8),
            Expanded(
              child: Text(
                date != null ? '${date.day}/${date.month}/${date.year}' : label,
                style: AppTheme.bodyMedium.copyWith(
                  color: date != null
                      ? AppTheme.primaryBlack
                      : AppTheme.neutralGray500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Confidence: ${(_minConfidence * 100).toInt()}%',
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: AppTheme.space12),
        Slider(
          value: _minConfidence,
          onChanged: (value) => setState(() => _minConfidence = value),
          divisions: 10,
        ),
      ],
    );
  }

  Widget _buildOrderByFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: AppTheme.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        const SizedBox(height: AppTheme.space12),
        Wrap(
          spacing: AppTheme.space8,
          children: ScanResultOrderBy.values.map((orderBy) {
            final isSelected = _orderBy == orderBy;
            return FilterChip(
              label: Text(_getOrderByLabel(orderBy)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _orderBy = orderBy);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHasNumbersFilter() {
    return Row(
      children: [
        Checkbox(
          value: _hasNumbersOnly,
          onChanged: (value) =>
              setState(() => _hasNumbersOnly = value ?? false),
        ),
        const SizedBox(width: AppTheme.space8),
        Expanded(
          child: Text(
            'Show only scans with numbers',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.primaryBlack),
          ),
        ),
      ],
    );
  }

  String _getOrderByLabel(ScanResultOrderBy orderBy) {
    return switch (orderBy) {
      ScanResultOrderBy.timestampAsc => 'Oldest First',
      ScanResultOrderBy.timestampDesc => 'Newest First',
      ScanResultOrderBy.confidenceAsc => 'Low Confidence',
      ScanResultOrderBy.confidenceDesc => 'High Confidence',
    };
  }

  void _applyFilters() {
    final filter = HistoryFilter(
      startDate: _startDate,
      endDate: _endDate,
      minConfidence: _minConfidence > 0 ? _minConfidence : null,
      orderBy: _orderBy,
      hasNumbers: _hasNumbersOnly ? true : null,
    );

    widget.onFilterApplied(filter);
    Navigator.of(context).pop();
  }
}
