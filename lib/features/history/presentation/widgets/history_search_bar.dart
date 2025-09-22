import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Search bar widget for history page
class HistorySearchBar extends StatefulWidget {
  const HistorySearchBar({
    required this.onSearchChanged,
    required this.onSearchCleared,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;

  @override
  State<HistorySearchBar> createState() => _HistorySearchBarState();
}

class _HistorySearchBarState extends State<HistorySearchBar> {
  final _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: AppTheme.neutralGray200),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search scans...',
          hintStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.neutralGray400,
          ),
          prefixIcon: const Icon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppTheme.neutralGray400,
          ),
          suffixIcon: _isSearchActive
              ? IconButton(
                  icon: const Icon(
                    PhosphorIconsRegular.x,
                    color: AppTheme.neutralGray400,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space16,
            vertical: AppTheme.space12,
          ),
        ),
      ),
    );
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _isSearchActive = query.isNotEmpty;
    });
    widget.onSearchChanged(query);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
    });
    widget.onSearchCleared();
  }
}
