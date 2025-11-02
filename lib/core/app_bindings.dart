import 'package:aivo/controllers/auth_controller.dart';
import 'package:aivo/controllers/chat_controller.dart';
import 'package:get/get.dart';

import '../controllers/model_settings_controller.dart';
import '../controllers/tts_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    Get.lazyPut<TtsController>(() => TtsController(), fenix: true);
    Get.lazyPut<ModelSettingsController>(() => ModelSettingsController(), fenix: true);
  }
}
