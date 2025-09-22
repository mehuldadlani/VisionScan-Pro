import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/domain/repositories/scan_repository.dart';

part 'generated/history_state.freezed.dart';
part 'generated/history_state.g.dart';

/// State for the history feature
@freezed
class HistoryState with _$HistoryState {
  /// Creates a [HistoryState] instance
  const factory HistoryState({
    @Default([]) List<ScanResult> scanResults,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default('') String searchQuery,
    @Default(null) DateTime? startDate,
    @Default(null) DateTime? endDate,
    @Default(ScanResultOrderBy.timestampDesc) ScanResultOrderBy orderBy,
    @Default(0) int currentPage,
    @Default(20) int pageSize,
    @Default(null) String? errorMessage,
    @Default(HistoryViewMode.list) HistoryViewMode viewMode,
    @Default([]) List<int> selectedItems,
    @Default(false) bool isSelectionMode,
  }) = _HistoryState;

  /// Creates a [HistoryState] from JSON
  factory HistoryState.fromJson(Map<String, dynamic> json) =>
      _$HistoryStateFromJson(json);
}

/// History view modes
enum HistoryViewMode {
  /// List view
  list,

  /// Grid view
  grid,

  /// Calendar view
  calendar,
}

/// History filter options
@freezed
class HistoryFilter with _$HistoryFilter {
  /// Creates a [HistoryFilter] instance
  const factory HistoryFilter({
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    double? minConfidence,
    double? maxConfidence,
    bool? hasNumbers,
    ScanResultOrderBy? orderBy,
  }) = _HistoryFilter;

  /// Creates a [HistoryFilter] from JSON
  factory HistoryFilter.fromJson(Map<String, dynamic> json) =>
      _$HistoryFilterFromJson(json);
}
