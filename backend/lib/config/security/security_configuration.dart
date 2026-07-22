import 'package:vaden/vaden.dart';
import 'package:vaden_security/vaden_security.dart';

@Configuration()
class SecurityConfiguration {
  @Bean()
  PasswordEncoder passwordEncoder() {
    return BCryptPasswordEncoder(cost: 10);
  }

  @Bean()
  JwtService jwtService(ApplicationSettings settings) {
    return JwtService.withSettings(settings);
  }

  @Bean()
  HttpSecurity httpSecurity() {
    return HttpSecurity([
      // Login/refresh/logout não podem exigir estar autenticado.
      RequestMatcher('/auth/**/*').permitAll(),
      RequestMatcher('/api/auth/**/*').permitAll(),
      RequestMatcher('/docs/**/*').permitAll(),
      RequestMatcher('/hello/**/*').permitAll(),
      // Leitura de pacotes é pública por design (roadmap itens 1 e 2). Cobre
      // também os GETs do publish (/versions/new, /versions/newUploadFinish).
      RequestMatcher('/api/packages/**/*', HttpMethod.get).permitAll(),
      // POST do passo 3.2 do publish: usa PublishTokens (resolvidos no
      // passo 3.1) carregados pela UploadSession, não Authorization — não
      // pode exigir sessão JWT aqui. Validado no próprio controller/service.
      RequestMatcher(
        '/api/packages/versions/newUpload',
        HttpMethod.post,
      ).permitAll(),
      AnyRequest().authenticated(),
    ]);
  }
}
