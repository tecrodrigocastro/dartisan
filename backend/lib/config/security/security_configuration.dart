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
      // Leitura de pacotes é pública por design (roadmap itens 1 e 2).
      RequestMatcher('/api/packages/**/*', HttpMethod.get).permitAll(),
      // Publish (item 3) usa PublishTokens, não JWT — validado no próprio
      // controller, não por esse middleware. O resto exige sessão JWT.
      AnyRequest().authenticated(),
    ]);
  }
}
