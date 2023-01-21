import 'package:chatapp_supabase/common/theme.dart';
import 'package:chatapp_supabase/pages/chat_page.dart';
import 'package:chatapp_supabase/pages/login_page.dart';
import 'package:chatapp_supabase/pages/register_page.dart';
import 'package:chatapp_supabase/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['url'].toString(),
    anonKey: dotenv.env['key'].toString(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/chat',
          page: () => const ChatPage(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterPage(),
        ),
        GetPage(
          name: '/splash',
          page: () => const SplashPage(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginPage(),
        ),
      ],
    );
  }
}
