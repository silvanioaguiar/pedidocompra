import 'dart:async';

import 'package:pedidocompra/services/auth/auth_service.dart';
import '../../models/ProtheusUser.dart';

class AuthMockService implements AuthService {
  static Map<String, ProtheusUser> _users = {};
  static ProtheusUser? _currentUser;
  static MultiStreamController<ProtheusUser?>? _controller;
  static final _userStream = Stream<ProtheusUser?>.multi((controller) {
    _controller = controller;
    _updateUser(null);
   });


  ProtheusUser? get currentUser {
    return _currentUser;
  }

  Stream<ProtheusUser?> get userChanges {
    return _userStream;
  }

  Future<void> login(
    String protheusUsername,
    String password,
  ) async {}

  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ProtheusUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
