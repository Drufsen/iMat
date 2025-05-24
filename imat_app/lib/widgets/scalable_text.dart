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
    Key? key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.color,
    this.fontWeight,
    this.softWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<TextSizeProvider>(context);
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    // Create a new style by combining the base style with any additional properties
    final combinedStyle = baseStyle.copyWith(
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
    );

    // Apply the scaling factor to the fontSize
    final scaledStyle = combinedStyle.copyWith(
      fontSize:
          combinedStyle.fontSize != null
              ? combinedStyle.fontSize! * textSizeProvider.textScale
              : null,
    );

    return Text(
      text,
      style: scaledStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
