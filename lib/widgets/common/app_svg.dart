import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a bundled SVG with optional tint and size.
class AppSvg extends StatelessWidget {
  final String asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const AppSvg({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
