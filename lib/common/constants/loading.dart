import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../generated/l10n.dart';

/// For Loading Widget
Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
    );

Widget kCustomFooter(context) => CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text(S.of(context).pullToLoadMore);
        } else if (mode == LoadStatus.loading) {
          body = kLoadingWidget(context);
        } else if (mode == LoadStatus.failed) {
          body = Text(S.of(context).loadFail);
        } else if (mode == LoadStatus.canLoading) {
          body = Text(S.of(context).releaseToLoadMore);
        } else {
          body = Text(S.of(context).noData);
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
