import 'package:aivo/utils/snackbar_utils.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../services/hive_service.dart';
import '../core/security.dart';
import '../models/user.dart';

class AuthController extends GetxController {
  final Rxn<User> user = Rxn<User>();
  final Rx<bool> isLogin = false.obs;
  final Rx<bool> isLoading = false.obs;
  Box<User> get _users => HiveService.getUsers();
  Box get _settings => HiveService.getSettings();

  bool get isLoggedIn => user.value != null;

  Future<void> handleAuth(String email, String password) async {
    isLoading.value = true;
    bool result = false;

    try {
      if (isLogin.value) {
        result = await login(email, password);
      } else {
        result = await register(email, password);
      }
    } catch (e) {
      SnackBarUtils.showErrorMessage("Something went wrong, please try again!");
    } finally {
      isLoading.value = false;
      if (result) {
        print("here going to chat route");
        Get.offNamed('/chat');
      } else if (isLogin.value && !result) {
        SnackBarUtils.showErrorMessage("Invalid username or password");
      } else if (!isLogin.value && !result) {
        SnackBarUtils.showErrorMessage("User already exists");
      }
    }
  }

  Future<bool> register(String email, String password) async {
    final exists = _users.values.any((u) => u.email == email);
    if (exists) return false;

    final salt = generateSalt();
    final hash = hashPassword(password, salt);
    final newUser = User(
      id: const Uuid().v4(),
      email: email,
      passwordHash: hash,
      salt: salt,
    );
    await _users.put(newUser.id, newUser);
    user.value = newUser;
    _settings.put("currentUserId", newUser.id);
    return true;
  }

  Future<bool> login(String email, String password) async {
    User? found;
    try {
      found = _users.values.firstWhere((u) => u.email == email);
    } catch (e) {
      found = null;
    }
    if (found == null) return false;
    final hash = hashPassword(password, found.salt);
    if (hash == found.passwordHash) {
      user.value = found;
      _settings.put("currentUserId", found.id);
      print("here returning true");
      return true;
    }
    return false;
  }

  Future<void> loadUser() async {
    final userId = _settings.get("currentUserId");
    if (userId == null) return;

    final existing = _users.get(userId);
    if (existing != null) {
      user.value = existing;
    }
  }

  void logout() {
    user.value = null;
    _settings.delete("currentUserId");
    Get.offAllNamed("/");
  }
}
