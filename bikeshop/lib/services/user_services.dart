import 'package:bikeshop/models/user_class.dart';

import 'superbase_service.dart';

class UserService {
  final SupabaseService _supabaseService = SupabaseService();
  UserService();

  Future<Users?> getUser() async {
    final client = _supabaseService.getSuperbaseClient();
    final userId = client.auth.currentUser!.id;
    final response =
        await client.from('users').select().eq('id', userId).single();

    if (response.isEmpty) {
      return null; // User not found or error occurred
    }
    print(response);
    final userData = response;

    return Users(
      id: userData['id'],
      updatedAt: DateTime.parse(userData['updated_at']),
      name: userData['name'] as String,
      birthDate: DateTime.parse(userData['birthdate']),
      avatarUrl: userData['avatar_url'] as String,
      email: userData['email'] as String,
      credits: userData['credits'] as int,
      isClient: userData['isclient'] as bool,
    );
  }
}
