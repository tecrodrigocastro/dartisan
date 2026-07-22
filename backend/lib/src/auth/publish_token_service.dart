import 'package:vaden/vaden.dart';

import 'publish_token_dto.dart';
import 'publish_token_repository.dart';
import 'token_hasher.dart';

abstract class PublishTokenService {
  Future<PublishTokenCreatedDTO> create(int userId);
  Future<List<PublishTokenDTO>> list(int userId);
  Future<bool> revoke(int userId, int tokenId);
}

@Service()
class PublishTokenServiceImpl implements PublishTokenService {
  final PublishTokenRepository _repository;

  PublishTokenServiceImpl(this._repository);

  @override
  Future<PublishTokenCreatedDTO> create(int userId) async {
    final rawToken = TokenHasher.generateRawToken();
    final row = await _repository.insert(
      userId: userId,
      tokenHash: TokenHasher.hash(rawToken),
    );

    return PublishTokenCreatedDTO(
      id: row.id,
      token: rawToken,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<List<PublishTokenDTO>> list(int userId) async {
    final rows = await _repository.findByUserId(userId);
    return rows
        .map(
          (row) => PublishTokenDTO(
            id: row.id,
            createdAt: row.createdAt,
            lastUsedAt: row.lastUsedAt,
            revokedAt: row.revokedAt,
          ),
        )
        .toList();
  }

  @override
  Future<bool> revoke(int userId, int tokenId) {
    return _repository.revoke(tokenId, userId: userId);
  }
}
