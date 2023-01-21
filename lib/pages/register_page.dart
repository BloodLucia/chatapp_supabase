import 'package:chatapp_supabase/common/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends HookWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameControllr = useTextEditingController();
    final showPassword = useState(true);
    Future<void> sinUp() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      final email = emailController.text;
      final password = passwordController.text;
      final username = usernameControllr.text;

      try {
        await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'username': username},
        );
        Get.offNamedUntil('/chat', (route) => false);
      } on AuthException catch (error) {
        context.showErrorSnackBar(message: error.message);
      } catch (error) {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// username
                    TextFormField(
                      controller: usernameControllr,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.people, color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请填写用户名';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// email
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        prefixIcon: Icon(Icons.email, color: Colors.indigo),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请填写邮箱';
                        }
                        if (!EmailValidator.validate(value)) {
                          return '请填写正确的邮箱地址';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// password
                    TextFormField(
                      controller: passwordController,
                      cursorColor: Theme.of(context).primaryColor,
                      obscureText: showPassword.value,
                      decoration: InputDecoration(
                        labelText: '密码',
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.indigo),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              showPassword.value = !showPassword.value,
                          icon: Icon(Icons.visibility,
                              color: !showPassword.value
                                  ? Colors.indigo
                                  : Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请填写密码';
                        }

                        if (value.length < 6) {
                          return '密码不能小于 6 位';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: isLoading.value ? null : sinUp,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '注册',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        text: '已经有账号了？',
                        children: [
                          TextSpan(
                            text: '现在登录',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed('/login');
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
        ),
      ),
    );
  }
}
