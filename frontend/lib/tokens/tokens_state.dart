import 'data/publish_token_models.dart';

sealed class TokensState {
  const TokensState();
}

class TokensLoading extends TokensState {
  const TokensLoading();
}

class TokensLoaded extends TokensState {
  final List<PublishToken> tokens;
  const TokensLoaded(this.tokens);
}

class TokensFailure extends TokensState {
  final String message;
  const TokensFailure(this.message);
}
