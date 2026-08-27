# Changelog

Registro do que foi feito no Dartisan, em ordem cronológica reversa. O
projeto ainda não tem versões numeradas (pré-1.0) — as entradas são
agrupadas por data.

## 2026-08-27

### Publicar pacotes a partir de repositórios privados do GitHub

- Tela `/publish/github` (perfil → aba Pacotes → "Importar do GitHub"):
  conecta a conta do GitHub, lista repositórios privados reais, escolhe
  branch/tag, importa e publica.
- Backend: `GET /api/github/connect` (vincula GitHub à conta já logada, sem
  criar/trocar de conta), `GET /api/github/repos`, `GET
  /api/github/repos/<owner>/<repo>/refs`, `POST /api/github/import`.
- O tarball que o GitHub devolve vem com um prefixo `owner-repo-sha/` — um
  reempacotador remove esse prefixo antes de passar pelo mesmo
  `PublishValidator` do publish via CLI.
- Pacotes importados ficam atribuídos ao usuário (`uploaderUserId`) mesmo
  sem publish token — "publicado por" continua funcionando.

### Login via GitHub OAuth

- Botão "Continuar com GitHub" no login. Conta nova nasce com role
  `reader` — só um admin promove pra `publisher` depois.
- Token do GitHub (access + refresh) fica guardado por usuário,
  criptografado (AES-256-GCM) — precisa ser reversível porque é reenviado
  ao GitHub depois (ex.: listar repositórios), diferente de senha/publish
  token, que só guardam hash.
- Refresh automático do token quando expira, sem exigir reconectar.

### Curtidas e contagem de downloads

- Botão de curtir (otimista) e sparkline de downloads dos últimos 30 dias
  na página de detalhe do pacote.
- Aba "Curtidas" no perfil.
- Contagem de download é best-effort — nunca derruba o download em si se
  falhar.

### Redesign visual

- Paleta "oficina de latão" (verdigris + latão sobre grafite quente) no
  lugar do azul-sobre-navy genérico de dev tool inicial.
- Tipografia: Fraunces (display), Public Sans (corpo), IBM Plex Mono
  (dados/código).
- Logo própria (dardo entrando numa caixa — trocadilho Dart + artisan),
  aplicada como favicon, ícones de PWA e dentro do app.
- Componentes reutilizáveis (`StatusPill`, `PackageCard`) substituindo
  badges/cards que cada tela reimplementava do zero.
- Datas formatadas em pt_BR em vez de timestamps ISO crus.
- Paginação real na home (antes só mostrava os 12 primeiros pacotes).

### Correções de bugs encontrados numa auditoria de ponta a ponta

Publicar um pacote de verdade contra o servidor local revelou três bugs
que os testes unitários não pegavam:

- `env.base_url` sem a porta (`http://localhost` em vez de
  `http://localhost:8080`) quebrava a URL de upload do
  `dart pub publish` — o CLI tentava conectar em `localhost:80`.
- Matcher de segurança `/docs/**/*` (com `/*` no final) não casava com a
  rota exata `/docs`, só com subrotas — bloqueava o Swagger UI sem barra
  final.
- Bug do gerador de código do Vaden: parâmetros `@Query` do tipo `int?`
  sempre lançavam exceção ao tentar converter de `String`, fazendo
  `GET /api/packages` (listagem paginada) sempre retornar 500 —
  contornado recebendo o parâmetro como `String?` e convertendo
  manualmente.

## 2026-08-07

- Redesign visual inicial do frontend (tema dark estilo pub.dev) +
  endpoints de suporte no backend.

## 2026-07-22

- Tela "Meus pacotes" (backend + frontend).
- Frontend Flutter Web (busca, página de pacote, login, painel de
  tokens) — roadmap item 6.
- Correção de bugs pré-existentes de CORS e `postgres.host` no backend.
- Fluxo de publicação de pacotes (`dart pub publish`) — roadmap item 3.
- Autenticação JWT + publish tokens — roadmap item 5.
- Tabelas `Users`/`RefreshTokens`/`PublishTokens` no Drift.
- Endpoint de metadados e download de pacotes — roadmap itens 1-2.
- Tabelas `Packages`/`PackageVersions` no Drift.

## 2026-07-21

- Scaffold inicial do backend (Vaden + Drift + Postgres) e do frontend
  (Flutter).
- Documentação do roadmap inicial em `docs/`.
