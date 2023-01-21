import 'package:chatapp_supabase/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasSession = useState<bool>(supabase.auth.currentSession == null);

    Future<void> redirect() async {
      await Future.delayed(Duration.zero);
      if (hasSession.value) {
        Get.offNamedUntil('/login', (route) => false);
      } else {
        Get.offNamedUntil('/chat', (route) => false);
      }
    }

    useEffect(() {
      redirect();
      return null;
    }, []);

    return const Scaffold(
      body: preloader,
    );
  }
}
