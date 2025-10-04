import 'package:dartway_flutter/dartway_flutter.dart';
import 'package:dartway_flutter/src/ui_kit/dw_default_text_style_presets.dart';
import 'package:flutter/material.dart';

@immutable
class DwFlutterTheme extends ThemeExtension<DwFlutterTheme> {
  const DwFlutterTheme({
    required this.multiLinkText,
    required this.multiLinkTextLink,
  });

  final DwTextStylePreset multiLinkText;
  final DwTextStylePreset multiLinkTextLink;

  @override
  DwFlutterTheme copyWith({
    DwTextStylePreset? multiLinkText,
    DwTextStylePreset? multiLinkTextLink,
  }) {
    return DwFlutterTheme(
      multiLinkText: multiLinkText ?? this.multiLinkText,
      multiLinkTextLink: multiLinkTextLink ?? this.multiLinkTextLink,
    );
  }

  @override
  DwFlutterTheme lerp(ThemeExtension<DwFlutterTheme>? other, double t) {
    if (other is! DwFlutterTheme) return this;

    return copyWith(
      multiLinkText: other.multiLinkText,
      multiLinkTextLink: other.multiLinkTextLink,
    );
  }

  static const fallback = DwFlutterTheme(
    multiLinkText: DwDefaultTextStyle.multiLinkText,
    multiLinkTextLink: DwDefaultTextStyle.multiLinkTextLink,
  );
}
