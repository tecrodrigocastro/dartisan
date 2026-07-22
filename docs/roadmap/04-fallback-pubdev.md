# 4. Fallback para pub.dev oficial

## Objetivo

Quando um pacote não existe no índice local, buscar no pub.dev oficial em vez de responder `404` direto — permite usar o Dartisan como *mirror* transparente, sem precisar publicar manualmente todas as dependências transitivas de um projeto.

## Onde entra no fluxo

Se aplica aos dois endpoints de leitura já documentados:

- [Metadados](01-metadados-pacote.md): `GET /api/packages/{name}` — se não achar em `Packages`, proxy para `https://pub.dev/api/packages/{name}`.
- [Download](02-download-tarball.md): `GET /api/packages/{name}/versions/{version}.tar.gz` — se não achar em `PackageVersions`, proxy para a `archive_url` que o pub.dev retornou nos metadados.

**Não** se aplica ao [fluxo de publicação](03-fluxo-publicacao.md) — publish é sempre local.

## Estratégia: proxy simples vs. cache-through

Para o roadmap inicial, implementar **proxy simples sem persistência**: a resposta do pub.dev é repassada ao cliente, mas não é gravada em `Packages`/`PackageVersions` nem no storage local. Motivo: cache-through introduz problemas de invalidação (pub.dev pode remover uma versão, ex. por questão de segurança) que não valem a complexidade nesta fase. Cache-through fica como melhoria futura, fora do roadmap inicial.

## Implementação

- Já existe um `Dio` configurado em [`backend/lib/config/dio/dio_configuration.dart`](../../backend/lib/config/dio/dio_configuration.dart), mas seu `baseUrl` vem de `settings['env']['base_url']` (hoje `http://localhost`, usado para outro propósito). **Não reaproveitar esse bean** — criar um segundo `Dio` dedicado com `baseUrl: 'https://pub.dev'`, registrado com um nome/qualifier diferente.
- `PackageService.findByName`: tenta repositório local primeiro; se `null`, chama `PubDevFallbackClient.fetchPackage(name)`; se o pub.dev também responder 404, aí sim propagar 404 ao cliente.
- Timeout curto (ex. 5s) no client do pub.dev — uma indisponibilidade externa não pode travar o servidor local indefinidamente.
- Erros de rede (pub.dev fora do ar) devem virar `404` pro cliente do `pub` também, não `500` — do ponto de vista do protocolo, "não consegui resolver" e "não existe" têm o mesmo efeito prático para quem chamou.

## Passos de implementação

1. `PubDevFallbackClient` com os dois métodos (`fetchPackage`, `fetchTarball`), usando o `Dio` dedicado.
2. Integrar no `PackageService` como fallback, conforme acima.
3. Configuração `env.pubdev_fallback_enabled` (bool, default `true`) em `application.yaml` — instalações que querem um índice 100% fechado precisam poder desligar isso.
