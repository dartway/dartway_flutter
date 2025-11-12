import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DwFlutterAppOptions {
  
  final ScrollBehavior? scrollBehavior;
  final String? restorationScopeId;
  final bool debugShowCheckedModeBanner;
  final List<Locale> supportedLocales;

  final LocaleResolutionCallback? localeResolutionCallback;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final List<LocalizationsDelegate<dynamic>> localizationDelegates;
  final Widget Function(BuildContext, Widget?)? builder;

  DwFlutterAppOptions({
    ScrollBehavior? scrollBehavior,
    this.restorationScopeId,
    this.debugShowCheckedModeBanner = false,
    this.supportedLocales = const [Locale('en')],
    this.localeResolutionCallback,
    this.localeListResolutionCallback,
    this.localizationDelegates = const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    this.builder,
  }) : scrollBehavior = scrollBehavior ?? defaultScrollBehavior;

  static final defaultScrollBehavior = MaterialScrollBehavior().copyWith(
    dragDevices: {...PointerDeviceKind.values},
  );
}
