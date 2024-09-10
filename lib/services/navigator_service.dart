import 'package:flutter/material.dart';

class NavigatorService {
  final _key = GlobalKey<NavigatorState>();

  static final NavigatorService _instance = NavigatorService._();

  NavigatorService._();

  static NavigatorService get instance {
    return _instance;
  }

  Future<T?> navigate<T>(WidgetBuilder builder) {
    return _key
      .currentState!
      .push(
        MaterialPageRoute(
          builder: builder
        )
      );
  }

  Future<T?> navigateTo<T>(String name) {
    return _key
      .currentState!
      .pushNamed(name);
  }

  void pop<T>([T? result]) => _key.currentState?.pop(result);

  GlobalKey<NavigatorState> get key => _key;
}