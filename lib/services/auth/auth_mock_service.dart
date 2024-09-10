import 'dart:async';

import 'package:pedidocompra/services/auth/auth_service.dart';
import '../../models/ProtheusUser.dart';

class AuthMockService implements AuthService {
  static final Map<String, ProtheusUser> _users = {};
  static ProtheusUser? _currentUser;
  static MultiStreamController<ProtheusUser?>? _controller;
  static final _userStream = Stream<ProtheusUser?>.multi((controller) {
    _controller = controller;
    _updateUser(null);
   });


  @override
  ProtheusUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<ProtheusUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> login(
    String protheusUsername,
    String password,
  ) async {}

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ProtheusUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
