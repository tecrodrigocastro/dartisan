/// Recusa subir fora do modo `debug` com os valores de exemplo do
/// `application.yaml` — segredo JWT público no repositório permitiria forjar
/// tokens de admin, e a senha padrão do Postgres é a primeira coisa testada.
const defaultSecuritySecret = 'troque-este-segredo-em-producao';
const defaultPostgresPassword = 'password';
const _minSecretLength = 32;

/// Retorna a lista de problemas (vazia = ok). Separada de [assertSafeSettings]
/// para ser testável sem derrubar o processo.
List<String> findUnsafeSettings({
  required String mode,
  required String securitySecret,
  required String postgresPassword,
}) {
  if (mode == 'debug') return const [];

  return [
    if (securitySecret == defaultSecuritySecret)
      'security.secret ainda é o valor padrão do repositório',
    if (securitySecret != defaultSecuritySecret &&
        securitySecret.length < _minSecretLength)
      'security.secret precisa ter pelo menos $_minSecretLength caracteres',
    if (postgresPassword == defaultPostgresPassword)
      'postgres.password ainda é o valor padrão ("$defaultPostgresPassword")',
  ];
}

void assertSafeSettings({
  required String mode,
  required String securitySecret,
  required String postgresPassword,
}) {
  final problems = findUnsafeSettings(
    mode: mode,
    securitySecret: securitySecret,
    postgresPassword: postgresPassword,
  );
  if (problems.isEmpty) return;

  throw StateError(
    'Configuração insegura para env.mode="$mode":\n'
    '${problems.map((p) => ' - $p').join('\n')}\n'
    'Troque esses valores no application.yaml (ou use env.mode: debug só em '
    'desenvolvimento).',
  );
}
