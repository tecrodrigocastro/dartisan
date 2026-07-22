# 2. Download de tarball de versão

## Objetivo

Servir o arquivo `.tar.gz` de uma versão específica de um pacote — é o `archive_url` retornado pelo [endpoint de metadados](01-metadados-pacote.md).

## Contrato

```
GET /api/packages/{name}/versions/{version}.tar.gz
```

- **200 OK** — `Content-Type: application/octet-stream`, corpo é o tarball bruto.
- **404 Not Found** — pacote ou versão inexistente (após tentar [fallback](04-fallback-pubdev.md), se aplicável).

Não há autenticação nesse endpoint — download é sempre público, mesmo para pacotes "privados" na v1 (autenticação de leitura fica fora do escopo do roadmap inicial; ver [autenticação](05-autenticacao.md)).

## Armazenamento

O `application.yaml` já modela três providers (`local`, `s3`, `firebase`) em `storage:`. Para o roadmap inicial, implementar apenas o provider `local` (`storage.local.folder`, hoje `./uploads`):

- Caminho em disco: `{storage.local.folder}/{package_name}/{version}.tar.gz`.
- `archivePath` salvo em `PackageVersions` (ver [modelo de dados do item 1](01-metadados-pacote.md#modelo-de-dados-drift)) é relativo a essa pasta, não absoluto — permite trocar o provider sem migrar dados.

Abstrair atrás de uma interface `PackageStorage` (`Future<Stream<List<int>>> read(String path)`, `Future<void> write(String path, Stream<List<int>> data)`) desde já, mesmo implementando só `local` agora — os providers `s3`/`firebase` já estão previstos na configuração e não devem exigir reescrever o controller depois.

## Validação de integridade

Ao servir o arquivo, **não** recalcular o SHA-256 a cada request (custo desnecessário) — o hash já foi validado uma vez no momento da publicação (ver [fluxo de publicação](03-fluxo-publicacao.md)) e fica armazenado em `archive_sha256`. O cliente (`dart pub`) confere esse hash contra o valor retornado nos metadados, não contra o arquivo em si.

## Passos de implementação

1. Interface `PackageStorage` + implementação `LocalPackageStorage` lendo `application.yaml` via `ApplicationSettings` (mesmo padrão usado em `DioConfiguration`).
2. Endpoint no mesmo `PackageController` do item 1, usando streaming (não carregar o tarball inteiro em memória).
3. 404 quando `PackageVersions` não tem registro para `(name, version)`.
