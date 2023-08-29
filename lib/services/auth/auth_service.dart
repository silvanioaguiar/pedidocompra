import 'package:pedidocompra/models/ProtheusUser.dart';

abstract class AuthService {
  ProtheusUser? get currentUser;

  Stream<ProtheusUser?> get userChanges;

  Future<void> login(
    String protheusUsername,
    String password,
  );
  Future<void> logout();
}
