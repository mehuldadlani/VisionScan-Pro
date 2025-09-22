// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryState _$HistoryStateFromJson(Map<String, dynamic> json) {
  return _HistoryState.fromJson(json);
}

/// @nodoc
mixin _$HistoryState {
  List<ScanResult> get scanResults => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  ScanResultOrderBy get orderBy => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  HistoryViewMode get viewMode => throw _privateConstructorUsedError;
  List<int> get selectedItems => throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryState value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryState value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryState value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HistoryState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryStateCopyWith<HistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryStateCopyWith<$Res> {
  factory $HistoryStateCopyWith(
          HistoryState value, $Res Function(HistoryState) then) =
      _$HistoryStateCopyWithImpl<$Res, HistoryState>;
  @useResult
  $Res call(
      {List<ScanResult> scanResults,
      bool isLoading,
      bool hasMore,
      String searchQuery,
      DateTime? startDate,
      DateTime? endDate,
      ScanResultOrderBy orderBy,
      int currentPage,
      int pageSize,
      String? errorMessage,
      HistoryViewMode viewMode,
      List<int> selectedItems,
      bool isSelectionMode});
}

/// @nodoc
class _$HistoryStateCopyWithImpl<$Res, $Val extends HistoryState>
    implements $HistoryStateCopyWith<$Res> {
  _$HistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanResults = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? searchQuery = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? orderBy = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? errorMessage = freezed,
    Object? viewMode = null,
    Object? selectedItems = null,
    Object? isSelectionMode = null,
  }) {
    return _then(_value.copyWith(
      scanResults: null == scanResults
          ? _value.scanResults
          : scanResults // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as ScanResultOrderBy,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as HistoryViewMode,
      selectedItems: null == selectedItems
          ? _value.selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryStateImplCopyWith<$Res>
    implements $HistoryStateCopyWith<$Res> {
  factory _$$HistoryStateImplCopyWith(
          _$HistoryStateImpl value, $Res Function(_$HistoryStateImpl) then) =
      __$$HistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ScanResult> scanResults,
      bool isLoading,
      bool hasMore,
      String searchQuery,
      DateTime? startDate,
      DateTime? endDate,
      ScanResultOrderBy orderBy,
      int currentPage,
      int pageSize,
      String? errorMessage,
      HistoryViewMode viewMode,
      List<int> selectedItems,
      bool isSelectionMode});
}

/// @nodoc
class __$$HistoryStateImplCopyWithImpl<$Res>
    extends _$HistoryStateCopyWithImpl<$Res, _$HistoryStateImpl>
    implements _$$HistoryStateImplCopyWith<$Res> {
  __$$HistoryStateImplCopyWithImpl(
      _$HistoryStateImpl _value, $Res Function(_$HistoryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanResults = null,
    Object? isLoading = null,
    Object? hasMore = null,
    Object? searchQuery = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? orderBy = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? errorMessage = freezed,
    Object? viewMode = null,
    Object? selectedItems = null,
    Object? isSelectionMode = null,
  }) {
    return _then(_$HistoryStateImpl(
      scanResults: null == scanResults
          ? _value._scanResults
          : scanResults // ignore: cast_nullable_to_non_nullable
              as List<ScanResult>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as ScanResultOrderBy,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as HistoryViewMode,
      selectedItems: null == selectedItems
          ? _value._selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryStateImpl implements _HistoryState {
  const _$HistoryStateImpl(
      {final List<ScanResult> scanResults = const [],
      this.isLoading = false,
      this.hasMore = false,
      this.searchQuery = '',
      this.startDate = null,
      this.endDate = null,
      this.orderBy = ScanResultOrderBy.timestampDesc,
      this.currentPage = 0,
      this.pageSize = 20,
      this.errorMessage = null,
      this.viewMode = HistoryViewMode.list,
      final List<int> selectedItems = const [],
      this.isSelectionMode = false})
      : _scanResults = scanResults,
        _selectedItems = selectedItems;

  factory _$HistoryStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryStateImplFromJson(json);

  final List<ScanResult> _scanResults;
  @override
  @JsonKey()
  List<ScanResult> get scanResults {
    if (_scanResults is EqualUnmodifiableListView) return _scanResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scanResults);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final DateTime? startDate;
  @override
  @JsonKey()
  final DateTime? endDate;
  @override
  @JsonKey()
  final ScanResultOrderBy orderBy;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final String? errorMessage;
  @override
  @JsonKey()
  final HistoryViewMode viewMode;
  final List<int> _selectedItems;
  @override
  @JsonKey()
  List<int> get selectedItems {
    if (_selectedItems is EqualUnmodifiableListView) return _selectedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedItems);
  }

  @override
  @JsonKey()
  final bool isSelectionMode;

  @override
  String toString() {
    return 'HistoryState(scanResults: $scanResults, isLoading: $isLoading, hasMore: $hasMore, searchQuery: $searchQuery, startDate: $startDate, endDate: $endDate, orderBy: $orderBy, currentPage: $currentPage, pageSize: $pageSize, errorMessage: $errorMessage, viewMode: $viewMode, selectedItems: $selectedItems, isSelectionMode: $isSelectionMode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._scanResults, _scanResults) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedItems, _selectedItems) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_scanResults),
      isLoading,
      hasMore,
      searchQuery,
      startDate,
      endDate,
      orderBy,
      currentPage,
      pageSize,
      errorMessage,
      viewMode,
      const DeepCollectionEquality().hash(_selectedItems),
      isSelectionMode);

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      __$$HistoryStateImplCopyWithImpl<_$HistoryStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)
        $default,
  ) {
    return $default(
        scanResults,
        isLoading,
        hasMore,
        searchQuery,
        startDate,
        endDate,
        orderBy,
        currentPage,
        pageSize,
        errorMessage,
        viewMode,
        selectedItems,
        isSelectionMode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)?
        $default,
  ) {
    return $default?.call(
        scanResults,
        isLoading,
        hasMore,
        searchQuery,
        startDate,
        endDate,
        orderBy,
        currentPage,
        pageSize,
        errorMessage,
        viewMode,
        selectedItems,
        isSelectionMode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<ScanResult> scanResults,
            bool isLoading,
            bool hasMore,
            String searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            ScanResultOrderBy orderBy,
            int currentPage,
            int pageSize,
            String? errorMessage,
            HistoryViewMode viewMode,
            List<int> selectedItems,
            bool isSelectionMode)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          scanResults,
          isLoading,
          hasMore,
          searchQuery,
          startDate,
          endDate,
          orderBy,
          currentPage,
          pageSize,
          errorMessage,
          viewMode,
          selectedItems,
          isSelectionMode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryState value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryState value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryState value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryStateImplToJson(
      this,
    );
  }
}

abstract class _HistoryState implements HistoryState {
  const factory _HistoryState(
      {final List<ScanResult> scanResults,
      final bool isLoading,
      final bool hasMore,
      final String searchQuery,
      final DateTime? startDate,
      final DateTime? endDate,
      final ScanResultOrderBy orderBy,
      final int currentPage,
      final int pageSize,
      final String? errorMessage,
      final HistoryViewMode viewMode,
      final List<int> selectedItems,
      final bool isSelectionMode}) = _$HistoryStateImpl;

  factory _HistoryState.fromJson(Map<String, dynamic> json) =
      _$HistoryStateImpl.fromJson;

  @override
  List<ScanResult> get scanResults;
  @override
  bool get isLoading;
  @override
  bool get hasMore;
  @override
  String get searchQuery;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  ScanResultOrderBy get orderBy;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  String? get errorMessage;
  @override
  HistoryViewMode get viewMode;
  @override
  List<int> get selectedItems;
  @override
  bool get isSelectionMode;

  /// Create a copy of HistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryStateImplCopyWith<_$HistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HistoryFilter _$HistoryFilterFromJson(Map<String, dynamic> json) {
  return _HistoryFilter.fromJson(json);
}

/// @nodoc
mixin _$HistoryFilter {
  String? get searchQuery => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  double? get minConfidence => throw _privateConstructorUsedError;
  double? get maxConfidence => throw _privateConstructorUsedError;
  bool? get hasNumbers => throw _privateConstructorUsedError;
  ScanResultOrderBy? get orderBy => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryFilter value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryFilter value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryFilter value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this HistoryFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HistoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HistoryFilterCopyWith<HistoryFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryFilterCopyWith<$Res> {
  factory $HistoryFilterCopyWith(
          HistoryFilter value, $Res Function(HistoryFilter) then) =
      _$HistoryFilterCopyWithImpl<$Res, HistoryFilter>;
  @useResult
  $Res call(
      {String? searchQuery,
      DateTime? startDate,
      DateTime? endDate,
      double? minConfidence,
      double? maxConfidence,
      bool? hasNumbers,
      ScanResultOrderBy? orderBy});
}

/// @nodoc
class _$HistoryFilterCopyWithImpl<$Res, $Val extends HistoryFilter>
    implements $HistoryFilterCopyWith<$Res> {
  _$HistoryFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HistoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? minConfidence = freezed,
    Object? maxConfidence = freezed,
    Object? hasNumbers = freezed,
    Object? orderBy = freezed,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minConfidence: freezed == minConfidence
          ? _value.minConfidence
          : minConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      maxConfidence: freezed == maxConfidence
          ? _value.maxConfidence
          : maxConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      hasNumbers: freezed == hasNumbers
          ? _value.hasNumbers
          : hasNumbers // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderBy: freezed == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as ScanResultOrderBy?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryFilterImplCopyWith<$Res>
    implements $HistoryFilterCopyWith<$Res> {
  factory _$$HistoryFilterImplCopyWith(
          _$HistoryFilterImpl value, $Res Function(_$HistoryFilterImpl) then) =
      __$$HistoryFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? searchQuery,
      DateTime? startDate,
      DateTime? endDate,
      double? minConfidence,
      double? maxConfidence,
      bool? hasNumbers,
      ScanResultOrderBy? orderBy});
}

/// @nodoc
class __$$HistoryFilterImplCopyWithImpl<$Res>
    extends _$HistoryFilterCopyWithImpl<$Res, _$HistoryFilterImpl>
    implements _$$HistoryFilterImplCopyWith<$Res> {
  __$$HistoryFilterImplCopyWithImpl(
      _$HistoryFilterImpl _value, $Res Function(_$HistoryFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of HistoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? minConfidence = freezed,
    Object? maxConfidence = freezed,
    Object? hasNumbers = freezed,
    Object? orderBy = freezed,
  }) {
    return _then(_$HistoryFilterImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minConfidence: freezed == minConfidence
          ? _value.minConfidence
          : minConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      maxConfidence: freezed == maxConfidence
          ? _value.maxConfidence
          : maxConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      hasNumbers: freezed == hasNumbers
          ? _value.hasNumbers
          : hasNumbers // ignore: cast_nullable_to_non_nullable
              as bool?,
      orderBy: freezed == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as ScanResultOrderBy?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryFilterImpl implements _HistoryFilter {
  const _$HistoryFilterImpl(
      {this.searchQuery,
      this.startDate,
      this.endDate,
      this.minConfidence,
      this.maxConfidence,
      this.hasNumbers,
      this.orderBy});

  factory _$HistoryFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryFilterImplFromJson(json);

  @override
  final String? searchQuery;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final double? minConfidence;
  @override
  final double? maxConfidence;
  @override
  final bool? hasNumbers;
  @override
  final ScanResultOrderBy? orderBy;

  @override
  String toString() {
    return 'HistoryFilter(searchQuery: $searchQuery, startDate: $startDate, endDate: $endDate, minConfidence: $minConfidence, maxConfidence: $maxConfidence, hasNumbers: $hasNumbers, orderBy: $orderBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryFilterImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.minConfidence, minConfidence) ||
                other.minConfidence == minConfidence) &&
            (identical(other.maxConfidence, maxConfidence) ||
                other.maxConfidence == maxConfidence) &&
            (identical(other.hasNumbers, hasNumbers) ||
                other.hasNumbers == hasNumbers) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, searchQuery, startDate, endDate,
      minConfidence, maxConfidence, hasNumbers, orderBy);

  /// Create a copy of HistoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryFilterImplCopyWith<_$HistoryFilterImpl> get copyWith =>
      __$$HistoryFilterImplCopyWithImpl<_$HistoryFilterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)
        $default,
  ) {
    return $default(searchQuery, startDate, endDate, minConfidence,
        maxConfidence, hasNumbers, orderBy);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)?
        $default,
  ) {
    return $default?.call(searchQuery, startDate, endDate, minConfidence,
        maxConfidence, hasNumbers, orderBy);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? searchQuery,
            DateTime? startDate,
            DateTime? endDate,
            double? minConfidence,
            double? maxConfidence,
            bool? hasNumbers,
            ScanResultOrderBy? orderBy)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(searchQuery, startDate, endDate, minConfidence,
          maxConfidence, hasNumbers, orderBy);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HistoryFilter value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HistoryFilter value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HistoryFilter value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryFilterImplToJson(
      this,
    );
  }
}

abstract class _HistoryFilter implements HistoryFilter {
  const factory _HistoryFilter(
      {final String? searchQuery,
      final DateTime? startDate,
      final DateTime? endDate,
      final double? minConfidence,
      final double? maxConfidence,
      final bool? hasNumbers,
      final ScanResultOrderBy? orderBy}) = _$HistoryFilterImpl;

  factory _HistoryFilter.fromJson(Map<String, dynamic> json) =
      _$HistoryFilterImpl.fromJson;

  @override
  String? get searchQuery;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  double? get minConfidence;
  @override
  double? get maxConfidence;
  @override
  bool? get hasNumbers;
  @override
  ScanResultOrderBy? get orderBy;

  /// Create a copy of HistoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HistoryFilterImplCopyWith<_$HistoryFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
