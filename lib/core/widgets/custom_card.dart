import 'package:flutter/material.dart';

/// Reusable polished Card container for LankaPulse Clean UI.
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderSide? borderSide;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;

    Widget content = Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Material(
        color: backgroundColor ?? cardTheme.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: borderSide ?? (cardTheme.shape as RoundedRectangleBorder).side,
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: content,
              )
            : content,
      ),
    );
  }
}
