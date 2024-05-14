class Users {
  final String id;
  final DateTime updatedAt;
  final String name;
  final DateTime birthDate;
  final String avatarUrl;
  final String email;
  final int credits;
  final bool isClient;

  Users({
    required this.id,
    required this.updatedAt,
    required this.name,
    required this.birthDate,
    required this.avatarUrl,
    required this.email,
    required this.credits,
    required this.isClient,
  });
}
