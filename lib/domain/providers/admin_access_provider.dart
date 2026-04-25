import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'user_profile_provider.dart';

final adminAccessProvider = Provider<bool>((Ref ref) {
  final profile = ref.watch(userProfileProvider);
  return profile.isAdmin;
});
