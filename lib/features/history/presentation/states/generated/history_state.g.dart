// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../history_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryStateImpl _$$HistoryStateImplFromJson(Map json) => $checkedCreate(
      r'_$HistoryStateImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'scan_results',
            'is_loading',
            'has_more',
            'search_query',
            'start_date',
            'end_date',
            'order_by',
            'current_page',
            'page_size',
            'error_message',
            'view_mode',
            'selected_items',
            'is_selection_mode'
          ],
        );
        final val = _$HistoryStateImpl(
          scanResults: $checkedConvert(
              'scan_results',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) => ScanResult.fromJson(
                          Map<String, dynamic>.from(e as Map)))
                      .toList() ??
                  const []),
          isLoading: $checkedConvert('is_loading', (v) => v as bool? ?? false),
          hasMore: $checkedConvert('has_more', (v) => v as bool? ?? false),
          searchQuery:
              $checkedConvert('search_query', (v) => v as String? ?? ''),
          startDate: $checkedConvert('start_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          endDate: $checkedConvert('end_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          orderBy: $checkedConvert(
              'order_by',
              (v) =>
                  $enumDecodeNullable(_$ScanResultOrderByEnumMap, v) ??
                  ScanResultOrderBy.timestampDesc),
          currentPage:
              $checkedConvert('current_page', (v) => (v as num?)?.toInt() ?? 0),
          pageSize:
              $checkedConvert('page_size', (v) => (v as num?)?.toInt() ?? 20),
          errorMessage:
              $checkedConvert('error_message', (v) => v as String? ?? null),
          viewMode: $checkedConvert(
              'view_mode',
              (v) =>
                  $enumDecodeNullable(_$HistoryViewModeEnumMap, v) ??
                  HistoryViewMode.list),
          selectedItems: $checkedConvert(
              'selected_items',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) => (e as num).toInt())
                      .toList() ??
                  const []),
          isSelectionMode:
              $checkedConvert('is_selection_mode', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'scanResults': 'scan_results',
        'isLoading': 'is_loading',
        'hasMore': 'has_more',
        'searchQuery': 'search_query',
        'startDate': 'start_date',
        'endDate': 'end_date',
        'orderBy': 'order_by',
        'currentPage': 'current_page',
        'pageSize': 'page_size',
        'errorMessage': 'error_message',
        'viewMode': 'view_mode',
        'selectedItems': 'selected_items',
        'isSelectionMode': 'is_selection_mode'
      },
    );

const _$$HistoryStateImplFieldMap = <String, String>{
  'scanResults': 'scan_results',
  'isLoading': 'is_loading',
  'hasMore': 'has_more',
  'searchQuery': 'search_query',
  'startDate': 'start_date',
  'endDate': 'end_date',
  'orderBy': 'order_by',
  'currentPage': 'current_page',
  'pageSize': 'page_size',
  'errorMessage': 'error_message',
  'viewMode': 'view_mode',
  'selectedItems': 'selected_items',
  'isSelectionMode': 'is_selection_mode',
};

abstract final class _$$HistoryStateImplJsonKeys {
  static const String scanResults = 'scan_results';
  static const String isLoading = 'is_loading';
  static const String hasMore = 'has_more';
  static const String searchQuery = 'search_query';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String orderBy = 'order_by';
  static const String currentPage = 'current_page';
  static const String pageSize = 'page_size';
  static const String errorMessage = 'error_message';
  static const String viewMode = 'view_mode';
  static const String selectedItems = 'selected_items';
  static const String isSelectionMode = 'is_selection_mode';
}

// ignore: unused_element
abstract class _$$HistoryStateImplPerFieldToJson {
  // ignore: unused_element
  static Object? scanResults(List<ScanResult> instance) =>
      instance.map((e) => e.toJson()).toList();
  // ignore: unused_element
  static Object? isLoading(bool instance) => instance;
  // ignore: unused_element
  static Object? hasMore(bool instance) => instance;
  // ignore: unused_element
  static Object? searchQuery(String instance) => instance;
  // ignore: unused_element
  static Object? startDate(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? endDate(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? orderBy(ScanResultOrderBy instance) =>
      _$ScanResultOrderByEnumMap[instance]!;
  // ignore: unused_element
  static Object? currentPage(int instance) => instance;
  // ignore: unused_element
  static Object? pageSize(int instance) => instance;
  // ignore: unused_element
  static Object? errorMessage(String? instance) => instance;
  // ignore: unused_element
  static Object? viewMode(HistoryViewMode instance) =>
      _$HistoryViewModeEnumMap[instance]!;
  // ignore: unused_element
  static Object? selectedItems(List<int> instance) => instance;
  // ignore: unused_element
  static Object? isSelectionMode(bool instance) => instance;
}

Map<String, dynamic> _$$HistoryStateImplToJson(_$HistoryStateImpl instance) =>
    <String, dynamic>{
      'scan_results': instance.scanResults.map((e) => e.toJson()).toList(),
      'is_loading': instance.isLoading,
      'has_more': instance.hasMore,
      'search_query': instance.searchQuery,
      if (instance.startDate?.toIso8601String() case final value?)
        'start_date': value,
      if (instance.endDate?.toIso8601String() case final value?)
        'end_date': value,
      'order_by': _$ScanResultOrderByEnumMap[instance.orderBy]!,
      'current_page': instance.currentPage,
      'page_size': instance.pageSize,
      if (instance.errorMessage case final value?) 'error_message': value,
      'view_mode': _$HistoryViewModeEnumMap[instance.viewMode]!,
      'selected_items': instance.selectedItems,
      'is_selection_mode': instance.isSelectionMode,
    };

const _$ScanResultOrderByEnumMap = {
  ScanResultOrderBy.timestampDesc: 'timestampDesc',
  ScanResultOrderBy.timestampAsc: 'timestampAsc',
  ScanResultOrderBy.idDesc: 'idDesc',
  ScanResultOrderBy.idAsc: 'idAsc',
  ScanResultOrderBy.confidenceDesc: 'confidenceDesc',
  ScanResultOrderBy.confidenceAsc: 'confidenceAsc',
};

const _$HistoryViewModeEnumMap = {
  HistoryViewMode.list: 'list',
  HistoryViewMode.grid: 'grid',
  HistoryViewMode.calendar: 'calendar',
};

_$HistoryFilterImpl _$$HistoryFilterImplFromJson(Map json) => $checkedCreate(
      r'_$HistoryFilterImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'search_query',
            'start_date',
            'end_date',
            'min_confidence',
            'max_confidence',
            'has_numbers',
            'order_by'
          ],
        );
        final val = _$HistoryFilterImpl(
          searchQuery: $checkedConvert('search_query', (v) => v as String?),
          startDate: $checkedConvert('start_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          endDate: $checkedConvert('end_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          minConfidence:
              $checkedConvert('min_confidence', (v) => (v as num?)?.toDouble()),
          maxConfidence:
              $checkedConvert('max_confidence', (v) => (v as num?)?.toDouble()),
          hasNumbers: $checkedConvert('has_numbers', (v) => v as bool?),
          orderBy: $checkedConvert('order_by',
              (v) => $enumDecodeNullable(_$ScanResultOrderByEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {
        'searchQuery': 'search_query',
        'startDate': 'start_date',
        'endDate': 'end_date',
        'minConfidence': 'min_confidence',
        'maxConfidence': 'max_confidence',
        'hasNumbers': 'has_numbers',
        'orderBy': 'order_by'
      },
    );

const _$$HistoryFilterImplFieldMap = <String, String>{
  'searchQuery': 'search_query',
  'startDate': 'start_date',
  'endDate': 'end_date',
  'minConfidence': 'min_confidence',
  'maxConfidence': 'max_confidence',
  'hasNumbers': 'has_numbers',
  'orderBy': 'order_by',
};

abstract final class _$$HistoryFilterImplJsonKeys {
  static const String searchQuery = 'search_query';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String minConfidence = 'min_confidence';
  static const String maxConfidence = 'max_confidence';
  static const String hasNumbers = 'has_numbers';
  static const String orderBy = 'order_by';
}

// ignore: unused_element
abstract class _$$HistoryFilterImplPerFieldToJson {
  // ignore: unused_element
  static Object? searchQuery(String? instance) => instance;
  // ignore: unused_element
  static Object? startDate(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? endDate(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? minConfidence(double? instance) => instance;
  // ignore: unused_element
  static Object? maxConfidence(double? instance) => instance;
  // ignore: unused_element
  static Object? hasNumbers(bool? instance) => instance;
  // ignore: unused_element
  static Object? orderBy(ScanResultOrderBy? instance) =>
      _$ScanResultOrderByEnumMap[instance];
}

Map<String, dynamic> _$$HistoryFilterImplToJson(_$HistoryFilterImpl instance) =>
    <String, dynamic>{
      if (instance.searchQuery case final value?) 'search_query': value,
      if (instance.startDate?.toIso8601String() case final value?)
        'start_date': value,
      if (instance.endDate?.toIso8601String() case final value?)
        'end_date': value,
      if (instance.minConfidence case final value?) 'min_confidence': value,
      if (instance.maxConfidence case final value?) 'max_confidence': value,
      if (instance.hasNumbers case final value?) 'has_numbers': value,
      if (_$ScanResultOrderByEnumMap[instance.orderBy] case final value?)
        'order_by': value,
    };
