import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/providers/scan_history_provider.dart';
import 'package:visionscan_pro/features/scan_details/presentation/widgets/scan_details_actions.dart';
import 'package:visionscan_pro/features/scan_details/presentation/widgets/scan_details_content.dart';
import 'package:visionscan_pro/features/scan_details/presentation/widgets/scan_details_header.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Simplified scan details page using separated widgets
class ScanDetailsPage extends ConsumerStatefulWidget {
  const ScanDetailsPage({required this.scanId, super.key});

  final String scanId;

  @override
  ConsumerState<ScanDetailsPage> createState() => _ScanDetailsPageState();
}

class _ScanDetailsPageState extends ConsumerState<ScanDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    final scanAsync = ref.watch(scanByIdProvider(widget.scanId));

    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      appBar: scanAsync.when(
        data: (scan) => scan != null
            ? ScanDetailsHeader(scan: scan)
            : _buildDefaultAppBar(),
        loading: _buildDefaultAppBar,
        error: (_, __) => _buildDefaultAppBar(),
      ),
      body: scanAsync.when(
        data: (scan) {
          if (scan == null) {
            return _buildNotFoundState();
          }
          return AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: _buildBody(scan),
              );
            },
          );
        },
        loading: _buildLoadingState,
        error: (error, stackTrace) => _buildErrorState(error.toString()),
      ),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryWhite,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: AppIconButton(
        icon: PhosphorIconsRegular.caretLeft,
        size: 44,
        variant: AppIconButtonVariant.ghost,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Scan Details',
        style: AppTheme.headlineMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryBlack,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody(ScanResult scan) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Main content
          ScanDetailsContent(scan: scan),

          // Actions section
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.space20,
              0,
              AppTheme.space20,
              AppTheme.space20,
            ),
            child: ScanDetailsActions(scan: scan),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppTheme.space16),
          Text('Loading scan details...'),
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
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
            'Scan Not Found',
            style: AppTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: AppTheme.space8),
          Text(
            'The requested scan could not be found.',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.neutralGray500),
            textAlign: TextAlign.center,
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
          const Icon(PhosphorIconsRegular.warning, size: 64, color: Colors.red),
          const SizedBox(height: AppTheme.space16),
          Text(
            'Error Loading Scan',
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
              ref.invalidate(scanByIdProvider(widget.scanId));
            },
            variant: AppButtonVariant.outline,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
