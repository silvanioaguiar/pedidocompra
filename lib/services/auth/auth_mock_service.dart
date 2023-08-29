import 'package:pedidocompra/services/auth/auth_service.dart';
import '../../models/ProtheusUser.dart';

class AuthMockService implements AuthService {
  ProtheusUser? get currentUser {
    return null;
  }

  Stream<ProtheusUser?> get userChanges {}

  Future<void> login(
    String protheusUsername,
    String password,
  ) async {}

  Future<void> logout() async {}
}
