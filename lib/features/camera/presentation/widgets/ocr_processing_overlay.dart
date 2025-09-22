import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/shared/presentation/widgets/app_components.dart';

/// Premium OCR processing overlay with Apple-inspired minimalist design
class OCRProcessingOverlay extends StatefulWidget {
  const OCRProcessingOverlay({
    required this.isProcessing,
    required this.onRetry,
    required this.onViewDetails,
    required this.onBackToCamera,
    this.result,
    this.error,
    super.key,
  });

  final bool isProcessing;
  final ScanResult? result;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onViewDetails;
  final VoidCallback onBackToCamera;

  @override
  State<OCRProcessingOverlay> createState() => _OCRProcessingOverlayState();
}

class _OCRProcessingOverlayState extends State<OCRProcessingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: ColoredBox(
              color: AppTheme.primaryBlack.withValues(alpha: 0.85),
              child: SafeArea(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: _buildContent(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (widget.isProcessing) {
      return _buildProcessingContent();
    } else if (widget.result != null) {
      return _buildSuccessContent();
    } else if (widget.error != null) {
      return _buildErrorContent();
    }
    return const SizedBox.shrink();
  }

  Widget _buildProcessingContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.space32),
        padding: const EdgeInsets.all(AppTheme.space40),
        decoration: NeumorphicDecoration.softCard(
          color: AppTheme.primaryWhite,
          borderRadius: AppTheme.radiusXLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Premium processing indicator
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neutralGray50,
                border: Border.all(color: AppTheme.neutralGray200),
                boxShadow: AppTheme.neumorphicShadow,
              ),
              child: const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryBlack,
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space32),
            Text(
              'PROCESSING',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: AppTheme.space16),
            Text(
              'Analyzing image for numbers and digits...',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.neutralGray600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.space32),
            // Premium progress indicator
            Container(
              width: double.infinity,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                color: AppTheme.neutralGray200,
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(1.5)),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryBlack,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    final result = widget.result!;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.space24),
        padding: const EdgeInsets.all(AppTheme.space32),
        decoration: NeumorphicDecoration.softCard(
          color: AppTheme.primaryWhite,
          borderRadius: AppTheme.radiusXLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neutralGray50,
                border: Border.all(color: AppTheme.neutralGray200),
                boxShadow: AppTheme.neumorphicShadow,
              ),
              child: const Icon(
                PhosphorIconsRegular.checkCircle,
                color: AppTheme.primaryBlack,
                size: 40,
              ),
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'SCAN COMPLETE',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppTheme.space12),
            Text(
              'Found ${result.extractedNumbers.length} number${result.extractedNumbers.length == 1 ? '' : 's'}',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.neutralGray600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppTheme.space24),
            // Preview of extracted numbers
            if (result.extractedNumbers.isNotEmpty)
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 200),
                padding: const EdgeInsets.all(AppTheme.space20),
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray50,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(color: AppTheme.neutralGray200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.space8),
                          decoration: NeumorphicDecoration.neumorphic(
                            color: AppTheme.primaryWhite,
                            borderRadius: AppTheme.radiusSmall,
                          ),
                          child: const Icon(
                            PhosphorIconsRegular.numberCircleTwo,
                            color: AppTheme.primaryBlack,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: AppTheme.space12),
                        Text(
                          'Extracted Numbers:',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: AppTheme.space8,
                          runSpacing: AppTheme.space8,
                          children: result.extractedNumbers.take(10).map((
                            number,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.space12,
                                vertical: AppTheme.space8,
                              ),
                              decoration: NeumorphicDecoration.neumorphic(
                                color: AppTheme.primaryWhite,
                              ),
                              child: Text(
                                number,
                                style: AppTheme.labelLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (result.extractedNumbers.length > 10)
                      Padding(
                        padding: const EdgeInsets.only(top: AppTheme.space12),
                        child: Text(
                          '+${result.extractedNumbers.length - 10} more numbers',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.neutralGray500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: AppTheme.space32),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: widget.onBackToCamera,
                    variant: AppButtonVariant.secondary,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsRegular.camera, size: 18),
                        SizedBox(width: AppTheme.space8),
                        Text('New Scan'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.space16),
                Expanded(
                  child: AppButton(
                    onPressed: widget.onViewDetails,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIconsRegular.eye,
                          size: 18,
                          color: AppTheme.primaryWhite,
                        ),
                        SizedBox(width: AppTheme.space8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.space32),
        padding: const EdgeInsets.all(AppTheme.space32),
        decoration: NeumorphicDecoration.softCard(
          color: AppTheme.primaryWhite,
          borderRadius: AppTheme.radiusXLarge,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.neutralGray50,
                border: Border.all(color: AppTheme.neutralGray200),
                boxShadow: AppTheme.neumorphicShadow,
              ),
              child: const Icon(
                PhosphorIconsRegular.warning,
                color: AppTheme.primaryBlack,
                size: 40,
              ),
            ),
            const SizedBox(height: AppTheme.space24),
            Text(
              'SCAN FAILED',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: AppTheme.space16),
            Container(
              padding: const EdgeInsets.all(AppTheme.space20),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray50,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                border: Border.all(color: AppTheme.neutralGray200),
              ),
              child: Text(
                widget.error!,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.neutralGray700,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppTheme.space32),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: widget.onBackToCamera,
                    variant: AppButtonVariant.secondary,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsRegular.camera, size: 18),
                        SizedBox(width: AppTheme.space8),
                        Text('Back to Camera'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.space16),
                Expanded(
                  child: AppButton(
                    onPressed: widget.onRetry,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsRegular.arrowClockwise, size: 18),
                        SizedBox(width: AppTheme.space8),
                        Text('Try Again'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
