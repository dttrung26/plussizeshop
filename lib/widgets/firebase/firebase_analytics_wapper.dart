import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

abstract class FirebaseAnalyticsAbs {
  init() {}
  getMNavigatorObservers() {
    return const <NavigatorObserver>[];
  }
}

class FirebaseAnalyticsWapper extends FirebaseAnalyticsAbs {
  FirebaseAnalytics analytics;

  @override
  init() {
    analytics = FirebaseAnalytics();

    return super.init();
  }

  @override
  getMNavigatorObservers() {
    return [
      FirebaseAnalyticsObserver(analytics: analytics),
    ];
  }
}

class FirebaseAnalyticsWeb extends FirebaseAnalyticsAbs {
  @override
  init() {
    return null;
  }
}
