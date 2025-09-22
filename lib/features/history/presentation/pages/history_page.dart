import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/history_filter.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/providers/scan_history_provider.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/history_empty_state.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/history_filter_sheet.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/history_list_view.dart';
import 'package:visionscan_pro/features/history/presentation/widgets/history_search_bar.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Simplified history page using separated widgets
class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  HistoryFilter? _currentFilter;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(opacity: _fadeAnimation.value, child: _buildBody());
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryWhite,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Scan History',
        style: AppTheme.headlineMedium.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: false,
      actions: [
        AppIconButton(
          icon: PhosphorIconsRegular.magnifyingGlass,
          size: 44,
          variant: AppIconButtonVariant.ghost,
          onPressed: _toggleSearch,
        ),
        const SizedBox(width: AppTheme.space8),
        AppIconButton(
          icon: PhosphorIconsRegular.list,
          size: 44,
          variant: AppIconButtonVariant.ghost,
          onPressed: _showFilterSheet,
        ),
        const SizedBox(width: AppTheme.space16),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Search bar (if active)
        if (_searchQuery.isNotEmpty)
          HistorySearchBar(
            onSearchChanged: _handleSearchChanged,
            onSearchCleared: _clearSearch,
          ),

        // Main content
        Expanded(child: _buildMainContent()),
      ],
    );
  }

  Widget _buildMainContent() {
    final scansAsync = ref.watch(scanHistoryProvider);

    return scansAsync.when(
      data: (scans) {
        final filteredScans = _applyFilters(scans);

        if (filteredScans.isEmpty) {
          return _searchQuery.isNotEmpty || _currentFilter != null
              ? _buildNoResultsState()
              : const HistoryEmptyState();
        }

        return HistoryListView(
          scans: filteredScans,
          onScanTap: _navigateToScanDetails,
        );
      },
      loading: _buildLoadingState,
      error: (error, stackTrace) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppTheme.space16),
          Text('Loading scan history...'),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsRegular.magnifyingGlass,
            size: 64,
            color: AppTheme.neutralGray400,
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'No Results Found',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            _searchQuery.isNotEmpty
                ? 'No scans match your search query.'
                : 'No scans match your current filters.',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGray500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space16),
          AppButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _currentFilter = null;
              });
            },
            variant: AppButtonVariant.outline,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsRegular.warning,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: AppTheme.space16),
          Text(
            'Error Loading History',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            error,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGray600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.space16),
          AppButton(
            onPressed: () {
              ref.invalidate(scanHistoryProvider);
            },
            variant: AppButtonVariant.outline,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<ScanResult> _applyFilters(List<ScanResult> scans) {
    var filteredScans = List<ScanResult>.from(scans);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredScans = filteredScans.where((scan) {
        return scan.extractedNumbers.any(
          (number) => number.toLowerCase().contains(_searchQuery.toLowerCase()),
        );
      }).toList();
    }

    // Apply other filters
    if (_currentFilter != null) {
      final filter = _currentFilter!;

      if (filter.startDate != null) {
        filteredScans = filteredScans
            .where((scan) => scan.timestamp.isAfter(filter.startDate!))
            .toList();
      }

      if (filter.endDate != null) {
        filteredScans = filteredScans
            .where((scan) => scan.timestamp.isBefore(filter.endDate!))
            .toList();
      }

      if (filter.minConfidence != null) {
        filteredScans = filteredScans
            .where((scan) => scan.confidence >= filter.minConfidence!)
            .toList();
      }

      if (filter.hasNumbers ?? false) {
        filteredScans = filteredScans
            .where((scan) => scan.extractedNumbers.isNotEmpty)
            .toList();
      }

      // Apply sorting
      if (filter.orderBy != null) {
        filteredScans.sort((a, b) {
          switch (filter.orderBy!) {
            case ScanResultOrderBy.timestampAsc:
              return a.timestamp.compareTo(b.timestamp);
            case ScanResultOrderBy.timestampDesc:
              return b.timestamp.compareTo(a.timestamp);
            case ScanResultOrderBy.confidenceAsc:
              return a.confidence.compareTo(b.confidence);
            case ScanResultOrderBy.confidenceDesc:
              return b.confidence.compareTo(a.confidence);
          }
        });
      }
    }

    return filteredScans;
  }

  void _toggleSearch() {
    setState(() {
      if (_searchQuery.isNotEmpty) {
        _searchQuery = '';
      } else {
        // Show search bar by setting a placeholder
        _searchQuery = ' ';
      }
    });
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HistoryFilterSheet(
        onFilterApplied: (filter) {
          setState(() {
            _currentFilter = filter;
          });
        },
        onFilterCleared: () {
          setState(() {
            _currentFilter = null;
          });
        },
      ),
    );
  }

  void _navigateToScanDetails(ScanResult scan) {
    context.push('/scan-details/${scan.id}');
  }
}
