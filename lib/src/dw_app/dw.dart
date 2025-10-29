import 'dart:async';

import 'package:dartway_flutter/dartway_flutter.dart';
import 'package:dartway_flutter/src/notifications/service/dw_notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'telegram_app/telegram_app.dart';

part 'parts/dw_navigation.dart';
part 'parts/dw_notifications.dart';
part 'parts/dw_services.dart';

final dw = _Dw();

class _Dw {
  late final DwConfig _config;
  bool isInitialized = false;

  final notify = _DwNotifications._();
  final services = _DwServices._();
  final navigation = _DwNavigation._();

  Future<bool> init(DwConfig config) async {
    await services._init(config: config);

    _config = config;

    isInitialized = true;

    return isInitialized;
  }

  void handleError(Object error, StackTrace stackTrace) {
    if (!isInitialized) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
    } else {
      _config.globalErrorHandler?.call(error, stackTrace);
    }
  }

  bool get isDefaultModelsGetterSetUp => _config.defaultModelGetter != null;

  T getDefaultModel<T>() {
    final getter = _config.defaultModelGetter;

    if (getter == null) {
      throw StateError(
        'DwToolkit.defaultModelGetter is not set. '
        'Please provide it in DwConfig when initializing DwApp',
      );
    }

    return getter<T>();
  }

  DwUiAction<T> action<T>(
    FutureOr<T> Function(BuildContext context) action, {
    FutureOr<void> Function(BuildContext mountedContext, T actionResult)?
    followUpIfMountedAction,
    String? onSuccessNotification,

    String? onErrorNotification,
    FutureOr<DwUiNotification> Function(T actionResult)?
    customNotificationBuilder,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    return DwUiAction<T>.create(
      action,
      followUpIfMountedAction: followUpIfMountedAction,
      onSuccessNotification: onSuccessNotification,
      customNotificationBuilder: customNotificationBuilder,
      onErrorNotification: onErrorNotification,
      onError: onError,
    );
  }

  // DwCallback contextCall<T>(
  //   BuildContext context,
  //   FutureOr<T> Function() action, {
  //   required FutureOr<void> Function(
  //     BuildContext mountedContext,
  //     T actionResult,
  //   )?
  //   followUpIfMountedAction,
  //   String? onSuccessNotification,
  //   FutureOr<DwUiNotification> Function(T actionResult)?
  //   customNotificationBuilder,
  //   String? onErrorNotification,
  //   void Function(Object error, StackTrace stackTrace)? onError,
  // }) {
  //   return DwCallback<T>.create(
  //     action,
  //     onSuccessNotification: onSuccessNotification,
  //     customNotificationBuilder: customNotificationBuilder,
  //     onErrorNotification: onErrorNotification,
  //     onError: onError,
  //     followUpIfMounted: followUpIfMountedAction,
  //   );
  // }
}
