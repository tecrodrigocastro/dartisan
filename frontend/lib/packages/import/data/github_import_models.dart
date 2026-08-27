class GithubRepo {
  final String owner;
  final String name;
  final String fullName;
  final bool private;

  const GithubRepo({
    required this.owner,
    required this.name,
    required this.fullName,
    required this.private,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) => GithubRepo(
    owner: json['owner'] as String,
    name: json['name'] as String,
    fullName: json['full_name'] as String,
    private: json['private'] as bool,
  );
}

class GithubRefs {
  final List<String> branches;
  final List<String> tags;

  const GithubRefs({required this.branches, required this.tags});

  factory GithubRefs.fromJson(Map<String, dynamic> json) => GithubRefs(
    branches: (json['branches'] as List).cast<String>(),
    tags: (json['tags'] as List).cast<String>(),
  );
}
