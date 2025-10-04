import 'package:flutter/material.dart';

/// Contract for style presets that can be resolved into [TextStyle]
/// in the given [BuildContext].
abstract class DwTextStylePreset {
  const DwTextStylePreset();

  TextStyle resolveStyle(BuildContext context);
}
