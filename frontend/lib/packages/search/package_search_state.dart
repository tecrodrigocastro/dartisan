/// A busca (item 1 do roadmap) é um lookup exato por nome — não há chamada
/// de API aqui, só validação do campo antes de navegar pra `/packages/:name`
/// (que já faz o fetch real). Por isso o único estado que faz sentido é a
/// validação do input.
sealed class PackageSearchState {
  const PackageSearchState();
}

class PackageSearchIdle extends PackageSearchState {
  const PackageSearchIdle();
}

class PackageSearchInvalid extends PackageSearchState {
  final String message;
  const PackageSearchInvalid(this.message);
}
