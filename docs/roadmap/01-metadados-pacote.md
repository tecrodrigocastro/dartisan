# 1. Endpoint de metadados de pacote

## Objetivo

Responder consultas do `dart pub` / `flutter pub` sobre quais versões de um pacote existem e onde baixar cada uma, no formato exigido pela [Pub repository spec v2](https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md#list-all-versions-of-a-package).

## Contrato

```
GET /api/packages/{name}
Accept: application/vnd.pub.v2+json
```

**200 OK**

```json
{
  "name": "meu_pacote",
  "latest": {
    "version": "1.2.0",
    "archive_url": "https://dartisan.exemplo.com/api/packages/meu_pacote/versions/1.2.0.tar.gz",
    "archive_sha256": "…",
    "pubspec": { "...": "conteúdo do pubspec.yaml da versão" }
  },
  "versions": [
    {
      "version": "1.0.0",
      "archive_url": "https://dartisan.exemplo.com/api/packages/meu_pacote/versions/1.0.0.tar.gz",
      "archive_sha256": "…",
      "pubspec": { "...": "..." }
    }
  ]
}
```

**404 Not Found** — pacote não existe localmente (nesse caso, ver [fallback para pub.dev](04-fallback-pubdev.md) antes de responder 404 pro cliente).

Corpo de erro segue o formato padrão da spec:

```json
{ "error": { "code": "not_found", "message": "Package meu_pacote not found" } }
```

## Modelo de dados (Drift)

Duas tabelas novas em `AppDatabase` ([`backend/lib/config/drift/app_database.dart`](../../backend/lib/config/drift/app_database.dart), hoje sem tabelas definidas):

- `Packages`: `name` (PK, text), `createdAt`, `latestVersion` (denormalizado para evitar `ORDER BY` em toda consulta).
- `PackageVersions`: `packageName` (FK), `version` (semver como texto, comparação via [`pub_semver`](https://pub.dev/packages/pub_semver)), `pubspecYaml` (texto bruto, parseado com [`pubspec_manager`](https://pub.dev/packages/pubspec_manager)), `archiveSha256`, `archivePath` (caminho no storage provider — ver `application.yaml` → `storage`), `uploadedAt`, `uploaderTokenId` (FK, ver [autenticação](05-autenticacao.md)).

`archive_url` é construído no momento da resposta (`{base_url}/api/packages/{name}/versions/{version}.tar.gz`), não é persistido — evita inconsistência se o domínio mudar.

## Passos de implementação

1. Definir as tabelas acima em `AppDatabase` e rodar `build_runner` (`drift_dev` já está no `pubspec.yaml`).
2. Criar `PackageController` com o endpoint `GET /api/packages/{name}` (padrão Vaden de controller, ver `HelloController` como referência de estrutura).
3. Repository/service que busca `Package` + `PackageVersions` ordenadas por semver (usar `pub_semver` para ordenar corretamente, não ordenação lexicográfica de string).
4. Serializar para o JSON da spec (`latest` = maior versão estável, `versions` = todas).
5. Se não encontrado, delegar ao fluxo de fallback antes de retornar 404.
