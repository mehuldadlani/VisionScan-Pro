import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Premium camera controls with CRED-inspired neumorphic design
class CameraControls extends StatefulWidget {
  const CameraControls({
    required this.onCapturePressed,
    required this.onGalleryPressed,
    required this.onFlashToggle,
    required this.isCapturing,
    required this.currentFlashMode,
    super.key,
  });

  final VoidCallback onCapturePressed;
  final VoidCallback onGalleryPressed;
  final ValueChanged<camera.FlashMode> onFlashToggle;
  final bool isCapturing;
  final camera.FlashMode currentFlashMode;

  @override
  State<CameraControls> createState() => _CameraControlsState();
}

class _CameraControlsState extends State<CameraControls>
    with TickerProviderStateMixin {
  late AnimationController _captureAnimationController;
  late AnimationController _pulseController;
  late Animation<double> _captureScaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _captureAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CameraControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCapturing != oldWidget.isCapturing) {
      if (widget.isCapturing) {
        _captureAnimationController.forward();
        _pulseController.stop();
      } else {
        _captureAnimationController.reverse();
        _pulseController.repeat(reverse: true);
      }
    }
  }

  void _initializeAnimations() {
    _captureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _captureScaleAnimation = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(
        parent: _captureAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start subtle pulse animation for capture button
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140 + bottomPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppTheme.primaryBlack.withValues(alpha: 0.3),
              AppTheme.primaryBlack.withValues(alpha: 0.8),
              AppTheme.primaryBlack.withValues(alpha: 0.95),
            ],
            stops: const [0.0, 0.4, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppTheme.space40,
              vertical: AppTheme.space20 + bottomPadding / 2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFlashButton(),
                    _buildCaptureButton(),
                    _buildGalleryButton(),
                  ],
                ),

                // Premium minimal indicator
                const SizedBox(height: AppTheme.space16),
                Container(
                  width: 32,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_captureScaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale:
              _captureScaleAnimation.value *
              (widget.isCapturing ? 1.0 : _pulseAnimation.value),
          child: GestureDetector(
            onTap: widget.isCapturing ? null : _handleCapturePressed,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isCapturing
                    ? AppTheme.primaryWhite.withValues(alpha: 0.3)
                    : AppTheme.primaryWhite,
                border: Border.all(
                  color: AppTheme.primaryWhite.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: widget.isCapturing
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.primaryWhite.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: AppTheme.primaryWhite.withValues(alpha: 0.8),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(-2, -2),
                        ),
                      ],
              ),
              child: _buildCaptureButtonContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCaptureButtonContent() {
    if (widget.isCapturing) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(AppTheme.neutralGray600),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(AppTheme.space8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryBlack, AppTheme.neutralGray800],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlack.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: const Icon(
        PhosphorIconsRegular.camera,
        size: 28,
        color: AppTheme.primaryWhite,
      ),
    );
  }

  Widget _buildFlashButton() {
    final flashState = _getFlashState();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryWhite.withValues(alpha: 0.1),
            border: Border.all(
              color: AppTheme.primaryWhite.withValues(alpha: 0.3),
            ),
          ),
          child: IconButton(
            icon: Icon(
              flashState.icon,
              color: flashState.isActive
                  ? AppTheme.primaryWhite
                  : AppTheme.primaryWhite.withValues(alpha: 0.7),
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _cycleFlashMode();
            },
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        Text(
          flashState.label,
          style: AppTheme.labelMedium.copyWith(
            color: flashState.isActive
                ? AppTheme.primaryWhite
                : AppTheme.primaryWhite.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primaryWhite.withValues(alpha: 0.1),
            border: Border.all(
              color: AppTheme.primaryWhite.withValues(alpha: 0.3),
            ),
          ),
          child: IconButton(
            icon: const Icon(
              PhosphorIconsRegular.images,
              color: AppTheme.primaryWhite,
              size: 24,
            ),
            onPressed: widget.onGalleryPressed,
          ),
        ),
        const SizedBox(height: AppTheme.space8),
        Text(
          'Gallery',
          style: AppTheme.labelMedium.copyWith(
            color: AppTheme.primaryWhite.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  _FlashState _getFlashState() {
    switch (widget.currentFlashMode) {
      case camera.FlashMode.auto:
        return const _FlashState(
          icon: PhosphorIconsRegular.lightning,
          label: 'Auto',
          isActive: true,
        );
      case camera.FlashMode.always:
        return const _FlashState(
          icon: PhosphorIconsFill.lightning,
          label: 'On',
          isActive: true,
        );
      case camera.FlashMode.torch:
        return const _FlashState(
          icon: PhosphorIconsRegular.sun,
          label: 'Torch',
          isActive: true,
        );
      case camera.FlashMode.off:
        return const _FlashState(
          icon: PhosphorIconsRegular.lightningSlash,
          label: 'Off',
          isActive: false,
        );
    }
  }

  void _cycleFlashMode() {
    camera.FlashMode nextMode;
    switch (widget.currentFlashMode) {
      case camera.FlashMode.off:
        nextMode = camera.FlashMode.auto;
      case camera.FlashMode.auto:
        nextMode = camera.FlashMode.always;
      case camera.FlashMode.always:
        nextMode = camera.FlashMode.torch;
      case camera.FlashMode.torch:
        nextMode = camera.FlashMode.off;
    }
    widget.onFlashToggle(nextMode);
  }

  void _handleCapturePressed() {
    if (widget.isCapturing) return;
    HapticFeedback.mediumImpact();
    widget.onCapturePressed();
  }
}

class _FlashState {
  const _FlashState({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;
}
