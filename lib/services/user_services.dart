import 'package:bikeshop/models/user_class.dart';

import 'superbase_service.dart';

Users? myUser;

class UserService {
  final SupabaseService _supabaseService = SupabaseService();
  UserService();

  Future<Users?> getUser() async {
    final client = _supabaseService.getSuperbaseClient();
    final userId = client.auth.currentUser!.id;
    
    final response = await client.from('users').select().eq('id', userId).single();
    print(response);
    if (response.isEmpty) {
      return null; // User not found or error occurred
    }
    final userData = response;
    print(userData);
    myUser = Users(
      id: userData['id'].toString(),
      updatedAt: DateTime.parse(userData['updated_at']),
      createdAt: DateTime.parse(userData['created_at']),
      firstName: userData['first_name'] as String,
      lastName: userData['last_name'] as String,
      birthDate: DateTime.parse(userData['birthdate']),
      avatarUrl: userData['avatar_url'].toString(),
      email: userData['email'] as String,
      credits: userData['credits'],
      isClient: userData['isclient'] as bool, isAdmin: userData['isAdmin'] as bool,
    );

    return myUser;
  }
}
