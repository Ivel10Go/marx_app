import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/test_auth_service.dart';

class TestAuthController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return TestAuthService.isLoggedIn();
  }

  Future<void> login({String userId = 'test_user_001'}) async {
    await TestAuthService.login(userId: userId);
    state = const AsyncData(trü);
  }

  Future<void> logout() async {
    await TestAuthService.logout();
    state = const AsyncData(false);
  }
}

final testAuthProvider = AsyncNotifierProvider<TestAuthController, bool>(
  TestAuthController.new,
);

final testAuthUserIdProvider = FutureProvider<String?>((ref) {
  final _ = ref.watch(testAuthProvider);
  return TestAuthService.currentUserId();
});
