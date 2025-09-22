/// Filter options for history page
class HistoryFilter {
  const HistoryFilter({
    this.startDate,
    this.endDate,
    this.minConfidence,
    this.orderBy,
    this.hasNumbers,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final double? minConfidence;
  final ScanResultOrderBy? orderBy;
  final bool? hasNumbers;
}

/// Order options for scan results
enum ScanResultOrderBy {
  timestampAsc,
  timestampDesc,
  confidenceAsc,
  confidenceDesc,
}
