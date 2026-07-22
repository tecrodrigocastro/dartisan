# 5. Autenticação (JWT + roles)

## Objetivo

Dois mecanismos de auth distintos, para dois consumidores distintos:

1. **JWT (access + refresh)** — usado pelo [frontend Flutter Web](06-frontend-web.md) (login de humano, sessão de navegador).
2. **Tokens de publicação** — usado pelo CLI (`dart pub publish`), consumidos no [fluxo de publicação](03-fluxo-publicacao.md).

São mecanismos separados porque o `dart pub` **não** faz login interativo com usuário/senha contra servidores customizados — ele só sabe enviar um `Bearer <token>` fixo, configurado uma vez via `dart pub token add <url>` (o token é colado manualmente pelo usuário, gerado antes pelo painel do frontend). Modelar isso como "JWT de usuário" seria forçar um fluxo OAuth que o cliente `pub` não implementa para hosts customizados.

## Roles

- `admin` — gerencia usuários e tokens de qualquer publisher.
- `publisher` — pode publicar novas versões de pacotes que possui (ou de qualquer pacote, se não houver ownership por pacote na v1 — a decidir ao implementar).
- `reader` — apenas leitura (relevante só se o index for fechado ao público; por padrão os endpoints de leitura são públicos, conforme os itens 1 e 2).

## JWT (sessão do frontend)

- Access token de vida curta (ex. 15 min) + refresh token de vida longa (ex. 7 dias), payload com `sub` (user id) e `role`.
- Dependência já presente no `pubspec.yaml` do backend: `vaden_security` — usar a integração de JWT que o pacote already oferece em vez de implementar assinatura/verificação na mão.
- Endpoints: `POST /api/auth/login`, `POST /api/auth/refresh`, `POST /api/auth/logout` (invalida refresh token — requer tabela `RefreshTokens` no Drift para permitir revogação).

## Tokens de publicação

- Tabela `PublishTokens` no Drift: `id`, `userId` (FK), `tokenHash` (nunca armazenar o token em texto puro — só o hash, igual senha), `createdAt`, `lastUsedAt`, `revokedAt`.
- Gerado uma vez no painel (frontend, ver [item 6](06-frontend-web.md)) e mostrado **uma única vez** ao usuário — o mesmo padrão de "personal access token" do GitHub.
- Validação no [passo 3.1 do fluxo de publicação](03-fluxo-publicacao.md#31--iniciar-upload): hash do token recebido bate com algum registro em `PublishTokens` não revogado → resolve `userId` e `role` a partir daí.

## Passos de implementação

1. Tabelas `Users`, `RefreshTokens`, `PublishTokens` no Drift.
2. Integração com `vaden_security` para emissão/verificação de JWT.
3. `AuthController` (login/refresh/logout) e `PublishTokenController` (criar/listar/revogar tokens — usado pelo painel).
4. Guard/middleware de role aplicado ao [passo 3.1 do publish](03-fluxo-publicacao.md) (exige `publisher`/`admin`) — os demais endpoints de leitura (itens 1, 2, 4) continuam sem guard.
