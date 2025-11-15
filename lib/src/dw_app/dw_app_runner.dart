import 'dart:async';

import 'package:dartway_flutter/dartway_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

typedef DwAppInitializer = FutureOr<bool> Function(WidgetRef ref);

class DwAppRunner {
  final List<DwAppInitializer>? appInitializers;

  final DwConfig dwConfig;

  final DwAppLoadingOptions appLoadingOptions;

  final DwRoutingConfig routingOptions;
  final Widget child;

  const DwAppRunner({
    this.appInitializers,
    this.dwConfig = const DwConfig(),
    this.routingOptions = const DwRoutingConfig(),
    this.appLoadingOptions = const DwAppLoadingOptions.withNativeSplash(),
    required this.child,
  });

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
        for (final locale in dwConfig.supportedLocales) {
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
          appInitializers: allInitializers,
          appLoadingOptions: appLoadingOptions,
          child: child,
        ),
      ),
    );
  }
}

class _DartWayApp extends ConsumerStatefulWidget {
  final List<DwAppInitializer> appInitializers;

  final DwAppLoadingOptions appLoadingOptions;
  final Widget child;

  const _DartWayApp({
    required this.appInitializers,
    required this.appLoadingOptions,
    required this.child,
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

    return widget.child;
  }
}
