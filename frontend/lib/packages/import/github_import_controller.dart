import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import 'data/github_import_api.dart';
import 'data/github_import_models.dart';
import 'github_import_state.dart';

class GithubImportController extends ValueNotifier<GithubImportState> {
  final GithubImportApi _api;

  GithubImportController(this._api) : super(const GithubImportLoading());

  Future<void> load() async {
    value = const GithubImportLoading();
    try {
      final connected = await _api.getConnectionStatus();
      if (!connected) {
        value = const GithubImportNotConnected();
        return;
      }
      final repos = await _api.listRepos();
      value = GithubImportReady(repos: repos);
    } on ApiException catch (e) {
      value = GithubImportLoadFailure(e.message);
    }
  }

  Future<void> selectRepo(GithubRepo repo) async {
    final current = value;
    if (current is! GithubImportReady) return;

    value = current.copyWith(
      selectedRepo: repo,
      loadingRefs: true,
      clearError: true,
    );
    try {
      final refs = await _api.listRefs(repo.owner, repo.name);
      final defaultRef = refs.branches.isNotEmpty
          ? refs.branches.first
          : (refs.tags.isNotEmpty ? refs.tags.first : null);
      value = (value as GithubImportReady).copyWith(
        refs: refs,
        selectedRef: defaultRef,
        loadingRefs: false,
      );
    } on ApiException catch (e) {
      value = (value as GithubImportReady).copyWith(loadingRefs: false, error: e.message);
    }
  }

  void selectRef(String ref) {
    final current = value;
    if (current is! GithubImportReady) return;
    value = current.copyWith(selectedRef: ref, clearError: true);
  }

  Future<void> submit() async {
    final current = value;
    if (current is! GithubImportReady) return;
    final repo = current.selectedRepo;
    final ref = current.selectedRef;
    if (repo == null || ref == null) return;

    value = current.copyWith(submitting: true, clearError: true);
    try {
      final packageName = await _api.importPackage(
        owner: repo.owner,
        repo: repo.name,
        ref: ref,
      );
      value = GithubImportSuccess(packageName);
    } on ApiException catch (e) {
      value = current.copyWith(submitting: false, error: e.message);
    }
  }
}
