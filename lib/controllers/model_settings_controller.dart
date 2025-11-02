import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../services/hive_service.dart';

class ModelSettingsController extends GetxController {
  Box get _settings => HiveService.getSettings();

  final selectedModel = "gemini".obs;

  @override
  void onInit() {
    selectedModel.value = _settings.get("model", defaultValue: "gemini");
    super.onInit();
  }

  void changeModel(String model) {
    selectedModel.value = model;
    _settings.put("model", model);
  }
}
