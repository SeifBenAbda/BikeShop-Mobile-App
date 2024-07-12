import '../models/user_class.dart';
import 'superbase_service.dart';

class AdminService {
  final SupabaseService _supabaseService = SupabaseService();

  //--------------Send Order to Server From Client--------------------------//

  Future<List<Users>> getWorkersFromServer() async {
    List<Users> workersList = [];
    try {
      final client = _supabaseService.getSuperbaseClient();
      final response = await client
          .from("users")
          .select()
          .eq("isAdmin", false)
          .eq("isclient", false);

      for (var workerData in response) {
        Users worker = createWorker(workerData);
        workersList.add(worker);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }

    return workersList;
  }

  Users createWorker(dynamic workerData) {
    Users worker = Users(
        id: workerData["id"].toString(),
        updatedAt: DateTime.parse(workerData["updated_at"].toString()), 
        firstName: workerData["first_name"],
        lastName: workerData["last_name"],
        birthDate: DateTime.parse(workerData["birthdate"].toString()),
        avatarUrl: workerData["avatar_url"].toString(),
        email: workerData["email"],
        credits: workerData["credits"].toString(),
        isClient: false,
        isAdmin: false,
        createdAt: DateTime.parse(workerData["created_at"].toString()));

    return worker;
  }
}
