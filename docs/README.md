# Docs

Documentação técnica do roadmap inicial do Dartisan. Cada arquivo em [`roadmap/`](roadmap/) detalha um item do roadmap listado no [README principal](../README.md): contrato de API, modelo de dados envolvido e passos de implementação.

Referência principal usada nesses documentos: [Pub repository spec v2](https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md) — é o protocolo que o `dart pub` / `flutter pub` espera de qualquer servidor de pacotes (oficial ou self-hosted).

## Itens

1. ✅ [Endpoint de metadados de pacote](roadmap/01-metadados-pacote.md)
2. ✅ [Download de tarball de versão](roadmap/02-download-tarball.md)
3. ✅ [Fluxo de publicação](roadmap/03-fluxo-publicacao.md)
4. ⏳ [Fallback para pub.dev oficial](roadmap/04-fallback-pubdev.md) — único item ainda não implementado
5. ✅ [Autenticação (JWT + roles)](roadmap/05-autenticacao.md)
6. ✅ [Frontend Flutter Web](roadmap/06-frontend-web.md)

## Ordem sugerida

Os itens 1–3 formam o núcleo do protocolo `pub` e devem ser feitos nessa ordem (metadados antes de download, download antes de publish, já que publish precisa reaproveitar a leitura de metadados para validar versões existentes). O item 4 (fallback) depende do item 1 já estar modelado, pois reusa o mesmo formato de resposta. O item 5 (auth) é pré-requisito apenas para a escrita (publish) — leitura de metadados/download pode ser pública desde o início. O item 6 (frontend) consome os endpoints dos itens 1–3.

## Além do roadmap inicial

Depois que os 6 itens acima ficaram prontos, o projeto ganhou funcionalidades que não estavam nesse documento original: login via GitHub OAuth, publicação de pacotes a partir de repositórios privados do GitHub (sem precisar do `dart pub publish` via CLI), curtidas e contagem de downloads por pacote, e um redesign visual completo do frontend. Nenhuma tem um doc de roadmap dedicado — o [CHANGELOG](../CHANGELOG.md) na raiz do repo é a referência pra saber o que foi feito e quando.
