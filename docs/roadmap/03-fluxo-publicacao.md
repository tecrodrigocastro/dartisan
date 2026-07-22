# 3. Fluxo de publicação

## Objetivo

Implementar o protocolo de 3 etapas que o `dart pub publish` / `flutter pub publish` executa contra qualquer servidor de pacotes, conforme a [Pub repository spec v2](https://github.com/dart-lang/pub/blob/master/doc/repository-spec-v2.md#publishing-packages). É o item mais complexo do roadmap inicial porque envolve autenticação, upload e validação de conteúdo.

## Contrato (3 requisições, nessa ordem)

### 3.1 — Iniciar upload

```
GET /api/packages/versions/new
Authorization: Bearer <token>
```

**200 OK**

```json
{
  "url": "https://dartisan.exemplo.com/api/packages/versions/newUpload",
  "fields": {}
}
```

`fields` fica vazio na nossa implementação (é usado por backends tipo S3 que exigem campos de assinatura no multipart; como o storage inicial é `local`, não precisamos disso — mas o cliente `pub` já sabe lidar com `fields` vazio).

### 3.2 — Upload do tarball

```
POST {url recebido no passo anterior}
Content-Type: multipart/form-data
```

Corpo multipart com um campo de arquivo contendo o `.tar.gz` gerado pelo `pub` (o cliente já empacota o pacote — o servidor só recebe e valida).

Resposta é um **redirect 302** para a URL de finalização (não um 200 direto — é assim que a spec define, para compatibilizar com providers de storage que fazem upload direto ao S3 e só depois notificam o servidor).

### 3.3 — Finalizar

```
GET /api/packages/versions/newUploadFinish
```

- **200 OK** com `{"success": {"message": "..."}}` se tudo certo.
- **400 Bad Request** com `{"error": {"code": "...", "message": "..."}}` em caso de erro de validação (mensagem é exibida diretamente ao usuário no terminal do `pub publish`, então deve ser legível).

## Validações obrigatórias antes de aceitar

1. **Autenticação**: token válido no passo 3.1 (ver [autenticação](05-autenticacao.md)); a role precisa ser `publisher` ou `admin`.
2. **Nome do pacote**: extraído do `pubspec.yaml` dentro do tarball (parseado com [`pubspec_manager`](https://pub.dev/packages/pubspec_manager), que preserva comentários caso o pacote seja re-servido). Nome no `pubspec.yaml` é a fonte da verdade, não um parâmetro de URL.
3. **Versão não pode já existir**: reusa a consulta de [metadados](01-metadados-pacote.md) — se `(name, version)` já está em `PackageVersions`, rejeitar com `400` (pacotes no `pub` são imutáveis por versão).
4. **Semver válido**: validar com [`pub_semver`](https://pub.dev/packages/pub_semver).
5. **Tamanho máximo do tarball** (configurável, evitar upload de lixo).
6. Calcular `sha256` do tarball recebido e persistir em `archive_sha256`.

## Passos de implementação

1. Três endpoints no `PackageController` (ou um `PublishController` dedicado, dado o número de etapas).
2. Middleware de auth aplicado só ao passo 3.1 (os passos 3.2/3.3 usam uma URL de upload temporária/assinada — não repetem o header `Authorization`, seguindo a spec).
3. Serviço de validação (`PublishValidator`) encapsulando as 6 checagens acima, retornando erros no formato `{error: {code, message}}` esperado pelo cliente.
4. Persistir tarball via `PackageStorage` (mesma abstração do [item 2](02-download-tarball.md)) e inserir linha em `PackageVersions`.
5. Testes de integração cobrindo: publish de pacote novo, publish de versão duplicada (deve falhar), publish sem token (401), publish com token sem role `publisher` (403).
