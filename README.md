# Dartisan — pub.dev self-hosted

> 🚧 **Em desenvolvimento inicial.** Ainda não há funcionalidades do roadmap implementadas — o backend é hoje apenas um scaffold (configuração de banco, OpenAPI, etc.). Não use em produção ainda.

## O que é

Um servidor de repositório de pacotes Dart/Flutter **self-hosted e open source**, compatível com o protocolo do `pub` (o mesmo usado pelo `dart pub` / `flutter pub`). A ideia é permitir que times e comunidades hospedem seu próprio índice de pacotes — públicos ou privados — sem depender de um serviço de terceiros pago, com todo o código (servidor incluído) aberto.

## Motivação

O ecossistema Dart/Flutter já tem soluções de repositório próprio, mas cada uma cobre uma parte do problema:

- **[PubNet](https://github.com/ricardoboss/PubNet)** — servidor em C#/.NET com frontend Blazor, suporte a fallback pro pub.dev oficial. Código aberto, mas fora do ecossistema Dart.
- **[unpub](https://github.com/pd4d10/unpub)** — servidor em Dart puro, arquitetura extensível (`MetaStore`/`PackageStore` plugáveis), mas com manutenção mais lenta.
- **[OnePub](https://github.com/onepub-dev/onepub)** — repositório privado de pacotes bem estabelecido, porém o **servidor é fechado** (SaaS pago); apenas o CLI cliente é open source (GPL v2).

Não existe hoje uma opção **100% aberta, com servidor incluso, mantida pela comunidade Dart/Flutter e fácil de hospedar**. É essa lacuna que este projeto busca preencher.

## Objetivo

Produto **open source**, feito para a comunidade, cobrindo o fluxo essencial do protocolo `pub`:

- Consulta de metadados de pacotes e versões
- Download de tarballs de pacotes
- Publicação de novas versões (`dart pub publish` / `flutter pub publish`)
- Fallback automático para o pub.dev oficial para pacotes que não existem localmente

## Arquitetura (visão geral)

| Camada | Tecnologia |
|---|---|
| Backend | [Vaden](https://github.com/Flutterando/vaden) (framework Dart inspirado em Spring Boot) |
| Banco de dados | PostgreSQL, via [Drift](https://drift.simonbinder.eu/) como ORM/query builder |
| Frontend | Flutter (Web) |
| Autenticação | JWT (access + refresh token), roles (`admin`, `publisher`, `reader`), tokens dedicados para publicação via CLI |

### Dependências de referência reaproveitáveis

- [`pubspec_manager`](https://pub.dev/packages/pubspec_manager) (MIT) — leitura/escrita de `pubspec.yaml` preservando comentários
- [`pub_semver`](https://pub.dev/packages/pub_semver) — resolução de versões semver, usado pelo próprio time do Dart

## Projetos de referência (links)

- PubNet: https://github.com/ricardoboss/PubNet
- unpub: https://github.com/pd4d10/unpub
- OnePub (CLI): https://github.com/onepub-dev/onepub
- Vaden (framework backend): https://github.com/Flutterando/vaden

## Roadmap inicial

- [ ] Endpoint de metadados de pacote (`GET /api/packages/{name}`)
- [ ] Download de tarball de versão
- [ ] Fluxo de publicação (`POST /api/packages/versions/new`)
- [ ] Fallback para pub.dev oficial
- [ ] Autenticação (JWT + roles)
- [ ] Frontend Flutter Web (busca, página de pacote, painel de tokens)

## Licença

MIT — em linha com o restante do ecossistema Dart/Flutter (incluindo dependências de referência como `pubspec_manager`) e sem incompatibilidade com dependências sob GPL.

## Como contribuir

O projeto ainda está em fase inicial (scaffold do backend, sem itens do roadmap implementados) e **não está aceitando contribuições externas por enquanto**. Guidelines de contribuição, setup local e como rodar os testes serão publicados assim que o fluxo essencial do protocolo `pub` estiver funcional.
