import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';

/// Bottom navigation bar
class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({required this.child, super.key});

  final Widget child;

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _selectionController;
  late Animation<double> _animation;
  late Animation<double> _selectionAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _selectionAnimation = CurvedAnimation(
      parent: _selectionController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    HapticFeedback.mediumImpact();
    _selectionController.forward().then((_) {
      _selectionController.reset();
    });

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/camera');
      case 1:
        context.go('/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update selected index based on current route
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/camera')) {
      _selectedIndex = 0;
    } else if (location.startsWith('/history')) {
      _selectedIndex = 1;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          widget.child,

          // Floating bottom navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _animation.value)),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: AppTheme.space20,
                      right: AppTheme.space20,
                      bottom: AppTheme.space20,
                    ),
                    child: SafeArea(
                      top: false,
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryWhite,
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlack.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: AppTheme.primaryBlack.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 10,
                              spreadRadius: -3,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.space4,
                            vertical: AppTheme.space4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildNavItem(
                                icon: PhosphorIconsRegular.camera,
                                activeIcon: PhosphorIconsFill.camera,
                                label: 'Camera',
                                index: 0,
                                isSelected: _selectedIndex == 0,
                              ),
                              _buildNavItem(
                                icon:
                                    PhosphorIconsRegular.clockCounterClockwise,
                                activeIcon:
                                    PhosphorIconsFill.clockCounterClockwise,
                                label: 'History',
                                index: 1,
                                isSelected: _selectedIndex == 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: AnimatedBuilder(
          animation: _selectionAnimation,
          builder: (context, child) {
            final scale = isSelected
                ? 1 + (_selectionAnimation.value * 0.1)
                : 1.0;
            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppTheme.primaryBlack.withValues(alpha: 0.05),
                        borderRadius: index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                              )
                            : const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                        border: Border.all(
                          width: 0.5,
                          color: AppTheme.primaryWhite,
                        ),
                      )
                    : BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.85,
                              end: 1,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        isSelected ? activeIcon : icon,
                        key: ValueKey(isSelected),
                        size: 22,
                        color: !isSelected
                            ? AppTheme.primaryBlack.withValues(alpha: 0.7)
                            : AppTheme.primaryBlack,
                      ),
                    ),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTheme.labelMedium.copyWith(
                        color: !isSelected
                            ? AppTheme.primaryBlack.withValues(alpha: 0.7)
                            : AppTheme.primaryBlack,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: 0.5,
                        fontSize: 11,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
