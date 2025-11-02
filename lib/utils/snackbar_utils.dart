import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarUtils {
  static void showErrorMessage(String message) {
    Get.snackbar(message, "",
        messageText: Container(),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        titleText: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 8,
        margin:
            const EdgeInsets.only(bottom: kToolbarHeight, left: 20, right: 20),
        snackPosition: SnackPosition.BOTTOM);
  }

  static void showSuccessMessage(String message) {
    Get.snackbar(
      message,
      "",
      messageText: Container(),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(
        Icons.done,
        color: Colors.white,
      ),
      borderRadius: 8,
      margin:
          const EdgeInsets.only(bottom: kToolbarHeight, left: 20, right: 20),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
