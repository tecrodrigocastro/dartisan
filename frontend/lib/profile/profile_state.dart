import 'data/me_models.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Me me;
  const ProfileLoaded(this.me);
}

class ProfileFailure extends ProfileState {
  final String message;
  const ProfileFailure(this.message);
}
