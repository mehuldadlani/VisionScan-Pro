import 'package:flutter/material.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Premium camera overlay with Apple-inspired minimalist design
///
/// Features:
/// - Fixed 4:3 aspect ratio rectangle with responsive sizing (85% of screen width)
/// - Clean subtle mask with neumorphic touches
/// - Elegant corner indicators with micro-animations
/// - Premium typography with proper spacing
/// - High contrast accessibility focus
class CameraOverlay extends StatefulWidget {
  const CameraOverlay({required this.isCapturing, super.key});

  final bool isCapturing;

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Start subtle animations
    _pulseController.repeat(reverse: true);
    _breathingController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rect = _getScanningRect(constraints);
        return Stack(
          children: [
            // Premium masking overlay with cutout
            _buildMaskingOverlay(rect),

            // Premium instruction text
            _buildInstructionText(constraints, rect),

            // Processing indicator with premium design
            if (widget.isCapturing) _buildProcessingIndicator(),
          ],
        );
      },
    );
  }

  Widget _buildMaskingOverlay(Rect rect) {
    return Positioned.fill(
      child: CustomPaint(painter: OverlayMaskPainter(scanningRect: rect)),
    );
  }

  Widget _buildInstructionText(BoxConstraints constraints, Rect rect) {
    return Positioned(
      top: rect.top - 80,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space24,
            vertical: AppTheme.space16,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Column(
            children: [
              // Clean, minimal title
              Text(
                'Position numbers in frame',
                style: AppTheme.headlineMedium.copyWith(
                  color: AppTheme.primaryWhite,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.space4),
              // Simple, clean subtitle
              Text(
                'Good lighting • Hold steady',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryWhite.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculate scanning rectangle with fixed 4:3 aspect ratio and responsive sizing
  Rect _getScanningRect(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;

    // Fixed aspect ratio (4:3 for optimal number scanning)
    const aspectRatio = 4 / 3;

    // Responsive sizing - use 85% of screen width for better visibility
    final rectWidth = screenWidth * 0.85;
    final rectHeight = rectWidth / aspectRatio;

    // Center the rectangle
    final left = (screenWidth - rectWidth) / 2;
    final top = (screenHeight - rectHeight) / 2;

    return Rect.fromLTWH(left, top, rectWidth, rectHeight);
  }

  Widget _buildProcessingIndicator() {
    return Positioned.fill(
      child: ColoredBox(
        color: AppTheme.primaryBlack.withValues(alpha: 0.6),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(AppTheme.space40),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlack.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              border: Border.all(
                color: AppTheme.primaryWhite.withValues(alpha: 0.2),
              ),
              boxShadow: AppTheme.elevatedShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryWhite,
                    ),
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(height: AppTheme.space24),
                Text(
                  'Processing',
                  style: AppTheme.titleMedium.copyWith(
                    color: AppTheme.primaryWhite,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: AppTheme.space8),
                Text(
                  'Extracting numbers from image',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium custom painter for the masking overlay
class OverlayMaskPainter extends CustomPainter {
  const OverlayMaskPainter({required this.scanningRect});
  final Rect scanningRect;

  @override
  void paint(Canvas canvas, Size size) {
    // Create a path for the entire screen with a hole for the scanning rectangle
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          scanningRect,
          const Radius.circular(AppTheme.radiusLarge),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    // Draw the dark overlay with transparency
    final overlayPaint = Paint()
      ..color = AppTheme.primaryBlack.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, overlayPaint);

    // Draw subtle gradient border around scanning rectangle
    final borderPaint = Paint()
      ..color = AppTheme.primaryWhite.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        scanningRect,
        const Radius.circular(AppTheme.radiusLarge),
      ),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant OverlayMaskPainter oldDelegate) =>
      oldDelegate.scanningRect != scanningRect;
}
