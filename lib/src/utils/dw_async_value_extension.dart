import 'package:dartway_flutter/dartway_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

extension DwAsyncValueX<T> on AsyncValue<T> {
  Widget dwBuildAsync({
    required Widget Function(T value) childBuilder,
    Widget errorWidget = const SizedBox.shrink(),
    T? loadingValue,
    Widget? loadingWidget,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = true,
  }) {
    return when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      data: (data) => childBuilder(data),
      error: (error, stackTrace) {
        dw.handleError(error, stackTrace);
        return errorWidget;
      },
      loading: () {
        if (loadingWidget != null) return loadingWidget;

        final fakeData = loadingValue ?? (null is T ? null as T : dw.getDefaultModel<T>());

        final built = childBuilder(fakeData);

        final isBuiltSliver =
            built is SliverList || built is SliverGrid || built is SliverToBoxAdapter || built is SliverPadding;

        if (loadingValue == null && !dw.isDefaultModelsGetterSetUp) {
          // 🧠 если дочерний виджет — sliver, используем SliverSkeletonizer
          if (isBuiltSliver) {
            return SliverToBoxAdapter(
              child: const SizedBox.shrink(),
            );
          }

          // 🧩 иначе обычный box-режим
          return const SizedBox.shrink();
        }

        // 🧠 если дочерний виджет — sliver, используем SliverSkeletonizer
        if (isBuiltSliver) {
          return SliverSkeletonizer(enabled: true, child: built);
        }

        // 🧩 иначе обычный box-режим
        return Skeletonizer(child: built);
      },
    );
  }
}
