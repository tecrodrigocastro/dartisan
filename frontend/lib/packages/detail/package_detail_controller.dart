import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';
import '../data/package_api.dart';
import 'package_detail_state.dart';

class PackageDetailController extends ValueNotifier<PackageDetailState> {
  final PackageRepository _repository;
  final AppSession _session;

  PackageDetailController(this._repository, this._session)
    : super(const PackageDetailLoading());

  Future<void> load(String name) async {
    value = const PackageDetailLoading();
    try {
      final metadata = await _repository.getMetadata(name);
      var likedByMe = false;
      if (_session.value is SessionAuthenticated) {
        // Falha em checar "curti isso?" não pode travar a página de detalhe
        // — o pacote em si já carregou, só o coração fica sem estado inicial.
        try {
          likedByMe = await _repository.isLikedByMe(name);
        } catch (_) {
          likedByMe = false;
        }
      }
      value = PackageDetailLoaded(metadata, likedByMe: likedByMe);
    } on ApiException catch (e) {
      value = e.code == 'not_found'
          ? PackageDetailNotFound(name)
          : PackageDetailFailure(e.message);
    } catch (e) {
      value = PackageDetailFailure(e.toString());
    }
  }

  /// Otimista: atualiza a UI antes da resposta do servidor, reverte se a
  /// chamada falhar (ex.: sessão expirou entre o load e o clique).
  Future<void> toggleLike() async {
    final current = value;
    if (current is! PackageDetailLoaded) return;

    final optimisticLiked = !current.likedByMe;
    final optimisticCount = current.metadata.likeCount + (optimisticLiked ? 1 : -1);
    value = PackageDetailLoaded(
      current.metadata.copyWith(likeCount: optimisticCount),
      likedByMe: optimisticLiked,
    );

    try {
      final (liked, count) = await _repository.toggleLike(current.metadata.name);
      value = PackageDetailLoaded(
        current.metadata.copyWith(likeCount: count),
        likedByMe: liked,
      );
    } catch (_) {
      value = current;
    }
  }
}
