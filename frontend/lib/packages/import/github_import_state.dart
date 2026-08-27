import 'data/github_import_models.dart';

sealed class GithubImportState {
  const GithubImportState();
}

class GithubImportLoading extends GithubImportState {
  const GithubImportLoading();
}

class GithubImportNotConnected extends GithubImportState {
  const GithubImportNotConnected();
}

class GithubImportLoadFailure extends GithubImportState {
  final String message;
  const GithubImportLoadFailure(this.message);
}

class GithubImportReady extends GithubImportState {
  final List<GithubRepo> repos;
  final GithubRepo? selectedRepo;
  final GithubRefs? refs;
  final String? selectedRef;
  final bool loadingRefs;
  final bool submitting;
  final String? error;

  const GithubImportReady({
    required this.repos,
    this.selectedRepo,
    this.refs,
    this.selectedRef,
    this.loadingRefs = false,
    this.submitting = false,
    this.error,
  });

  GithubImportReady copyWith({
    GithubRepo? selectedRepo,
    GithubRefs? refs,
    String? selectedRef,
    bool? loadingRefs,
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return GithubImportReady(
      repos: repos,
      selectedRepo: selectedRepo ?? this.selectedRepo,
      refs: refs ?? this.refs,
      selectedRef: selectedRef ?? this.selectedRef,
      loadingRefs: loadingRefs ?? this.loadingRefs,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Import concluído — a página navega pro pacote e descarta esse estado.
class GithubImportSuccess extends GithubImportState {
  final String packageName;
  const GithubImportSuccess(this.packageName);
}
