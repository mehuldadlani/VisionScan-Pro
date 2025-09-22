import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Premium button component with neumorphic design
class AppButton extends StatefulWidget {
  const AppButton({
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final double? width;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetButton();
  }

  void _handleTapCancel() {
    _resetButton();
  }

  void _resetButton() {
    if (mounted) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.isEnabled && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: isEnabled ? widget.onPressed : null,
            child: Container(
              width: widget.width,
              height: widget.size.height,
              decoration: _getDecoration(),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            widget.variant.foregroundColor,
                          ),
                        ),
                      )
                    : DefaultTextStyle(
                        style: widget.size.textStyle.copyWith(
                          color: isEnabled 
                              ? widget.variant.foregroundColor 
                              : AppTheme.neutralGray400,
                        ),
                        child: widget.child,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _getDecoration() {
    final isEnabled = widget.isEnabled && !widget.isLoading;
    
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return BoxDecoration(
          color: isEnabled ? AppTheme.primaryBlack : AppTheme.neutralGray300,
          borderRadius: BorderRadius.circular(widget.size.borderRadius),
          boxShadow: isEnabled && !_isPressed ? AppTheme.softShadow : null,
        );
      
      case AppButtonVariant.secondary:
        return NeumorphicDecoration.neumorphic(
          color: AppTheme.primaryWhite,
          borderRadius: widget.size.borderRadius,
          pressed: _isPressed,
        );
      
      case AppButtonVariant.outline:
        return BoxDecoration(
          color: AppTheme.primaryWhite,
          borderRadius: BorderRadius.circular(widget.size.borderRadius),
          border: Border.all(
            color: isEnabled ? AppTheme.primaryBlack : AppTheme.neutralGray300,
            width: 1.5,
          ),
          boxShadow: !_isPressed ? AppTheme.softShadow : null,
        );
      
      case AppButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed 
              ? AppTheme.neutralGray100 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.size.borderRadius),
        );
    }
  }
}

/// Button variants for different use cases
enum AppButtonVariant {
  primary,
  secondary,
  outline,
  ghost;

  Color get foregroundColor {
    switch (this) {
      case AppButtonVariant.primary:
        return AppTheme.primaryWhite;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return AppTheme.primaryBlack;
    }
  }
}

/// Button sizes with consistent spacing
enum AppButtonSize {
  small,
  medium,
  large;

  double get height {
    switch (this) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double get borderRadius {
    switch (this) {
      case AppButtonSize.small:
        return AppTheme.radiusSmall;
      case AppButtonSize.medium:
        return AppTheme.radiusMedium;
      case AppButtonSize.large:
        return AppTheme.radiusLarge;
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case AppButtonSize.small:
        return AppTheme.labelMedium;
      case AppButtonSize.medium:
        return AppTheme.labelLarge;
      case AppButtonSize.large:
        return AppTheme.titleMedium;
    }
  }
}

/// Premium card component with soft shadows
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevated = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: elevated 
          ? NeumorphicDecoration.softCard()
          : BoxDecoration(
              color: AppTheme.primaryWhite,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              border: Border.all(
                color: AppTheme.neutralGray200,
              ),
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.space20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Icon button with neumorphic design
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.variant = AppIconButtonVariant.neumorphic,
    this.isActive = false,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final AppIconButtonVariant variant;
  final bool isActive;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    _resetButton();
  }

  void _handleTapCancel() {
    _resetButton();
  }

  void _resetButton() {
    if (mounted) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onPressed,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: _getDecoration(),
              child: Icon(
                widget.icon,
                size: widget.size * 0.5,
                color: _getIconColor(),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _getDecoration() {
    switch (widget.variant) {
      case AppIconButtonVariant.neumorphic:
        return NeumorphicDecoration.neumorphic(
          color: widget.isActive ? AppTheme.primaryBlack : AppTheme.neutralGray100,
          borderRadius: widget.size / 2,
          pressed: _isPressed,
        );
      
      case AppIconButtonVariant.outline:
        return BoxDecoration(
          color: widget.isActive ? AppTheme.primaryBlack : AppTheme.primaryWhite,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.neutralGray300,
            width: 1.5,
          ),
          boxShadow: !_isPressed ? AppTheme.softShadow : null,
        );
      
      case AppIconButtonVariant.ghost:
        return BoxDecoration(
          color: _isPressed || widget.isActive 
              ? AppTheme.neutralGray100 
              : Colors.transparent,
          shape: BoxShape.circle,
        );
    }
  }

  Color _getIconColor() {
    if (widget.isActive) {
      return widget.variant == AppIconButtonVariant.neumorphic 
          ? AppTheme.primaryWhite 
          : AppTheme.primaryWhite;
    }
    return AppTheme.primaryBlack;
  }
}

enum AppIconButtonVariant {
  neumorphic,
  outline,
  ghost,
}

/// Bottom sheet component with premium design
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.title,
    required this.children,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<Widget> children, String? subtitle,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AppBottomSheet(
        title: title,
        subtitle: subtitle,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: AppTheme.primaryWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXLarge),
          topRight: Radius.circular(AppTheme.radiusXLarge),
        ),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: AppTheme.space12),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.space24),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.space8),
                  Text(
                    subtitle!,
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: AppTheme.space24,
                right: AppTheme.space24,
                bottom: AppTheme.space32,
              ),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
}
