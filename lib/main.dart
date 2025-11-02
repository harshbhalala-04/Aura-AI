import 'package:aivo/core/app_bindings.dart';
import 'package:aivo/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'screens/chat_screen.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Chat MVP',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: AppBindings(),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => FutureBuilder(
            future: Get.find<AuthController>().loadUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return Get.find<AuthController>().isLoggedIn
                  ? ChatScreen()
                  : const AuthScreen();
            },
          ),
        ),
        GetPage(name: '/chat', page: () => ChatScreen()),
      ],
    );
  }
}
