import 'package:chatapp_supabase/common/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends HookWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormKey = useMemoized(GlobalKey<FormState>.new, const []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState(false);
    final isMounted = useIsMounted();

    final sinUp = useCallback(() async {
      isLoading.value = true;
      final isValid = loginFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      final email = emailController.text;
      final password = passwordController.text;
      try {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        Get.offNamedUntil('/chat', (route) => false);
      } on AuthException catch (e) {
        context.showErrorSnackBar(message: e.message);
      } catch (_) {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
      if (isMounted()) {
        isLoading.value = true;
      }
    }, [loginFormKey]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: '邮箱',
                    prefixIcon: Icon(Icons.email, color: Colors.indigo),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '请输入邮箱';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '密码',
                    prefixIcon: Icon(Icons.lock, color: Colors.indigo),
                    suffixIcon: Icon(Icons.visibility, color: Colors.grey),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '请输入密码';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: sinUp,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '登录',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: '还没有账号？',
                    children: [
                      TextSpan(
                        text: '现在注册',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/register');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
