import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/message.dart';

class HiveService {
  static const String usersBox = 'users_box';
  static const String messagesBox = 'messages_box';
  static const String appSettingsBox = "app_settings_box";

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(MessageRoleAdapter());
    Hive.registerAdapter(MessageAdapter());

    // Open boxes
    await Hive.openBox<User>(usersBox);
    await Hive.openBox<Message>(messagesBox);
    await Hive.openBox(appSettingsBox);
  }

  static Box<User> getUsers() => Hive.box<User>(usersBox);
  static Box<Message> getMessages() => Hive.box<Message>(messagesBox);
  static Box getSettings() => Hive.box(appSettingsBox);
}
