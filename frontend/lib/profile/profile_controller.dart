import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import 'data/me_api.dart';
import 'profile_state.dart';

class ProfileController extends ValueNotifier<ProfileState> {
  final MeApi _api;

  ProfileController(this._api) : super(const ProfileLoading());

  Future<void> load() async {
    value = const ProfileLoading();
    try {
      final me = await _api.getMe();
      value = ProfileLoaded(me);
    } on ApiException catch (e) {
      value = ProfileFailure(e.message);
    }
  }
}
