import 'package:flutter/material.dart';

/// 3D Button with shadow effect like Duolingo
class Button3D extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double depth;

  const Button3D({
    super.key,
    required this.child,
    required this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = 16,
    this.padding,
    this.depth = 6,
  });

  @override
  State<Button3D> createState() => _Button3DState();
}

class _Button3DState extends State<Button3D> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveDepth = _isPressed ? 0.0 : widget.depth;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? widget.depth : 0, 0),
        child: Stack(
          children: [
            // Shadow/Bottom layer
            Container(
              margin: EdgeInsets.only(top: effectiveDepth),
              decoration: BoxDecoration(
                color: widget.gradient != null
                    ? widget.gradient!.colors.first.withValues(alpha: 0.4)
                    : (widget.backgroundColor ?? Colors.blue).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              height: 56 + effectiveDepth,
            ),
            // Top layer (button)
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.gradient != null
                      ? widget.gradient!.colors.last.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 3D Card with depth effect
class Card3D extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final double depth;

  const Card3D({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.backgroundColor,
    this.depth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDark ? const Color(0xFF2D3748) : Colors.white);
    
    return Stack(
      children: [
        // Shadow layer
        Container(
          margin: EdgeInsets.only(top: depth),
          decoration: BoxDecoration(
            color: bgColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        // Main card
        Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark 
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              width: 2,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
