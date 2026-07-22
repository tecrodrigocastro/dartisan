# 6. Frontend Flutter Web

## Objetivo

Painel web consumindo os endpoints dos itens anteriores. Projeto já criado em [`frontend/`](../../frontend) (scaffold padrão `flutter create`, multiplataforma — o alvo relevante para este item é apenas `web/`).

## Telas

1. **Busca** — campo de busca + lista de pacotes. Consome `GET /api/packages/{name}` para lookup exato; busca por substring/relevância não faz parte do roadmap inicial (a spec do pub não define um endpoint de search — teria que ser um endpoint próprio, fora de escopo por ora). Na v1, a "busca" pode ser só um lookup direto por nome exato.
2. **Página de pacote** — versões disponíveis, `pubspec.yaml` renderizado, botão de download do tarball. Consome o mesmo `GET /api/packages/{name}` do [item 1](01-metadados-pacote.md).
3. **Login** — formulário de usuário/senha contra `POST /api/auth/login` ([item 5](05-autenticacao.md)), guarda access/refresh token (ex. `flutter_secure_storage` ou equivalente web-safe).
4. **Painel de tokens** — para usuários com role `publisher`/`admin`: listar, criar e revogar tokens de publicação (`PublishTokenController`, [item 5](05-autenticacao.md)). Token recém-criado é mostrado uma única vez, com aviso explícito de "copie agora, não será mostrado de novo".

## Estrutura sugerida

- Client HTTP: `dio` (mesma lib já usada no backend, mantém consistência de stack) com interceptor de refresh automático de access token expirado.
- Estado: a decidir pelo time (Provider/Riverpod/Bloc) — não é uma decisão que pertence a este documento de roadmap.
- Roteamento: `go_router`, com guard de rota para o painel de tokens (redireciona a `/login` se não autenticado).

## Passos de implementação

1. Definir gerenciamento de estado e roteamento (dependências a adicionar em `frontend/pubspec.yaml`).
2. Client HTTP tipado para os endpoints dos itens 1–3 e 5 (`PackageApi`, `AuthApi`, `PublishTokenApi`).
3. Tela de busca + página de pacote (não dependem de autenticação — podem ser feitas antes do item 5 estar pronto no backend).
4. Tela de login + painel de tokens (dependem do [item 5](05-autenticacao.md) estar implementado no backend).
