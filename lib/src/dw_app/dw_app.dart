import 'dart:async';

import 'package:dartway_flutter/dartway_flutter.dart';
import 'package:dartway_flutter/src/ui_kit/theme/dw_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../notifications/ui/dw_notifications_listener.dart';
import '../notifications/ui/dw_ui_notification_handler.dart';

typedef DwAppInitializer = FutureOr<bool> Function(WidgetRef ref);

class DwApp {
  final String title;
  final ProviderBase<RouterConfig<Object>> routerProvider;
  final ProviderBase<DwAppTheme> themeProvider;
  final List<DwAppInitializer>? appInitializers;
  final DwConfig dwConfig;
  final DwAppLoadingOptions appLoadingOptions;
  final DwFlutterAppOptions _flutterAppOptions;
  final DwRoutingConfig routingOptions;

  final Function(BuildContext context, Widget child)? appWrapper;

  DwApp({
    this.title = 'Dart Way App',
    required this.routerProvider,
    required this.themeProvider,
    this.appInitializers,
    this.appWrapper,
    this.routingOptions = const DwRoutingConfig(),
    this.dwConfig = const DwConfig(),
    this.appLoadingOptions = const DwAppLoadingOptions.withNativeSplash(),
    DwFlutterAppOptions? flutterAppOptions,
  }) : _flutterAppOptions = flutterAppOptions ?? DwFlutterAppOptions();

  void _preInit() {
    final binding = WidgetsFlutterBinding.ensureInitialized();

    if (appLoadingOptions.useNativeSplash) {
      FlutterNativeSplash.preserve(widgetsBinding: binding);
    }

    routingOptions.init();
  }

  void run() {
    _preInit();

    final allInitializers = <DwAppInitializer>[
      (_) async {
        for (final locale in _flutterAppOptions.supportedLocales) {
          await initializeDateFormatting(locale.languageCode);
        }
        return true;
      },
      (_) => dw.init(dwConfig),
      ...?appInitializers,
      if (appLoadingOptions.useNativeSplash)
        (_) {
          FlutterNativeSplash.remove();
          return true;
        },
    ];

    runApp(
      ProviderScope(
        child: _DartWayApp(
          title: title,
          routerProvider: routerProvider,
          themeProvider: themeProvider,
          appInitializers: allInitializers,
          appLoadingOptions: appLoadingOptions,
          flutterAppOptions: _flutterAppOptions,
          appWrapper: appWrapper,
        ),
      ),
    );
  }
}

class _DartWayApp extends ConsumerStatefulWidget {
  final String title;
  final ProviderBase<RouterConfig<Object>> routerProvider;
  final ProviderBase<DwAppTheme> themeProvider;
  final List<DwAppInitializer> appInitializers;
  final Function(BuildContext context, Widget child)? appWrapper;

  final DwFlutterAppOptions flutterAppOptions;
  final DwAppLoadingOptions appLoadingOptions;

  const _DartWayApp({
    required this.title,
    required this.routerProvider,
    required this.appInitializers,
    required this.flutterAppOptions,
    required this.appLoadingOptions,
    required this.themeProvider,
    this.appWrapper,
  });

  @override
  ConsumerState<_DartWayApp> createState() => _DartWayAppWidgetState();
}

class _DartWayAppWidgetState extends ConsumerState<_DartWayApp> {
  bool _initialized = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _runInitializers();
  }

  Future<void> _runInitializers() async {
    try {
      for (final fn in widget.appInitializers) {
        final ok = await fn(ref);
        if (!ok) throw Exception('initializer failed');
      }
      setState(() => _initialized = true);
    } catch (e, s) {
      dw.handleError(e, s);
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.appLoadingOptions.errorScreen;
    if (!_initialized) return widget.appLoadingOptions.loadingScreen;

    final routerApp = Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(widget.routerProvider);
        final dwTheme = ref.watch(widget.themeProvider);

        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner:
              widget.flutterAppOptions.debugShowCheckedModeBanner,
          title: widget.title,
          theme: dwTheme.theme,
          darkTheme: dwTheme.darkTheme,
          themeMode: dwTheme.themeMode,
          scrollBehavior: widget.flutterAppOptions.scrollBehavior,
          restorationScopeId: widget.flutterAppOptions.restorationScopeId,
          builder: (context, child) {
            final wrappedWithNotifications = DwNotificationsListener(
              handlers: {DwUiNotification: DwUiNotificationHandler()},
              child: child!,
            );
            
            final customBuilt = widget.flutterAppOptions.builder != null
                ? widget.flutterAppOptions.builder!(context, wrappedWithNotifications)
                : wrappedWithNotifications;
            
            return customBuilt;
          },
          supportedLocales: widget.flutterAppOptions.supportedLocales,
          localizationsDelegates:
              widget.flutterAppOptions.localizationDelegates,
          localeResolutionCallback:
              widget.flutterAppOptions.localeResolutionCallback,
          localeListResolutionCallback:
              widget.flutterAppOptions.localeListResolutionCallback,
        );
      },
    );

    final wrappedApp = widget.appWrapper != null
        ? widget.appWrapper!(context, routerApp)
        : routerApp;

    return wrappedApp;
  }
}
