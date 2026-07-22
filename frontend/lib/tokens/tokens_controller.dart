import 'package:flutter/foundation.dart';

import '../core/error/api_exception.dart';
import 'data/publish_token_api.dart';
import 'data/publish_token_models.dart';
import 'tokens_state.dart';

class TokensController extends ValueNotifier<TokensState> {
  final PublishTokenRepository _repository;

  TokensController(this._repository) : super(const TokensLoading());

  Future<void> load() async {
    value = const TokensLoading();
    try {
      final tokens = await _repository.list();
      value = TokensLoaded(tokens);
    } on ApiException catch (e) {
      value = TokensFailure(e.message);
    }
  }

  /// O token bruto só existe nesta resposta — a página é responsável por
  /// mostrá-lo uma única vez pro usuário. Recarrega a lista em seguida.
  Future<PublishTokenCreated> create() async {
    final created = await _repository.create();
    await load();
    return created;
  }

  Future<void> revoke(int id) async {
    await _repository.revoke(id);
    await load();
  }
}
