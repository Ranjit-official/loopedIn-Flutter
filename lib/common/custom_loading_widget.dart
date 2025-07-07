import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatefulWidget {
  final double size;
  final Color? color;
  final String? message;

  const CustomLoadingWidget({
    super.key,
    this.size = 100,
    this.color,
    this.message,
  });

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int _circleCount = 5;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _circleCount,
      (index) => AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _circleCount; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _controllers[i].repeat(
            reverse: true,
          ); // Add reverse for to-and-fro motion
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF007AFF);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              children: List.generate(_circleCount, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    final progress = _animations[index].value;
                    final x = 35 + (progress * 130); // Move from 35 to 165
                    final opacity = 1.0 - (index * 0.2); // Decreasing opacity

                    return Positioned(
                      left: x - 15, // Center the circle
                      top: widget.size / 2 - 15,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// Full screen loading overlay
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoading({super.key, this.message, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: CustomLoadingWidget(
        size: 80,
        color: Colors.white,
        message: message,
      ),
    );
  }
}

// Small loading indicator for buttons or small areas
class SmallLoadingWidget extends StatefulWidget {
  final double size;
  final Color? color;

  const SmallLoadingWidget({super.key, this.size = 24, this.color});

  @override
  State<SmallLoadingWidget> createState() => _SmallLoadingWidgetState();
}

class _SmallLoadingWidgetState extends State<SmallLoadingWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int _circleCount = 5;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _circleCount,
      (index) => AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    }).toList();

    // Start animations with staggered delays
    for (int i = 0; i < _circleCount; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          _controllers[i].repeat(
            reverse: true,
          ); // Add reverse for to-and-fro motion
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? const Color(0xFF007AFF);
    final circleSize = widget.size / 3;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: List.generate(_circleCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final progress = _animations[index].value;
              final x = (progress * widget.size * 0.8); // Move across the width
              final opacity = 1.0 - (index * 0.2); // Decreasing opacity

              return Positioned(
                left: x,
                top: widget.size / 2 - circleSize / 2,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
