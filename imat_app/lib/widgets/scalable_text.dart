import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';

class ScalableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softWrap;

  const ScalableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.color,
    this.fontWeight,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = Provider.of<TextSizeProvider>(context).textScale;

    return Text(
      text,
      style: style?.copyWith(
        fontSize: (style?.fontSize ?? 14) * textScale,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
