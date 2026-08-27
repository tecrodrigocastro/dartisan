import 'package:vaden/vaden.dart';

@DTO()
class GithubRepoDTO {
  final String owner;
  final String name;

  @JsonKey('full_name')
  final String fullName;
  final bool private;

  GithubRepoDTO({
    required this.owner,
    required this.name,
    required this.fullName,
    required this.private,
  });
}

@DTO()
class GithubRefsDTO {
  final List<String> branches;
  final List<String> tags;

  GithubRefsDTO({required this.branches, required this.tags});
}

@DTO()
class GithubImportRequestDTO {
  final String owner;
  final String repo;
  final String ref;

  GithubImportRequestDTO({required this.owner, required this.repo, required this.ref});
}
