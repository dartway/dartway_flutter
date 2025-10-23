import 'package:flutter/widgets.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

import '../configs/dw_telegram_web_app_config.dart';
import 'telegram_app.dart';

class TelegramAppImpl implements TelegramApp {
  const TelegramAppImpl();

  @override
  Future<void> init(DwTelegramWebAppConfig telegramWebAppConfig) async {
    print('TelegramAppImpl init');

    try {
      if (!TelegramWebApp.instance.isSupported) return;
    } catch (_) {
      return; // при ошибке — значит не в Telegram
    }

    // Try to initialize Telegram WebApp with retries in case it is not ready yet
    for (var i = 0; i < 3; i++) {
      try {
        TelegramWebApp.instance.ready();
        if (telegramWebAppConfig.disableVerticalSwipes) {
          TelegramWebApp.instance.disableVerticalSwipes();
        }
        if (telegramWebAppConfig.expand) {
          await Future.delayed(
            Duration(milliseconds: 100 * i),
            TelegramWebApp.instance.expand,
          );
        }

        return;
      } catch (e) {
        debugPrint("Telegram WebApp init error: $e");
      }
    }
  }

  @override
  EdgeInsets get safeAreaInset {
    final insets = TelegramWebApp.instance.safeAreaInset;
    return EdgeInsets.fromLTRB(
      insets.left.toDouble(),
      insets.top.toDouble(),
      insets.right.toDouble(),
      insets.bottom.toDouble(),
    );
  }

  @override
  int? get telegramUserId => TelegramWebApp.instance.initDataUnsafe?.user?.id;
}
