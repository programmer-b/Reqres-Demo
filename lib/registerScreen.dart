import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:reqres_demo/ApiProvider.dart';
import 'package:reqres_demo/commons.dart';
import 'package:reqres_demo/homeScreen.dart';
import 'package:reqres_demo/loginScreen.dart';
import 'package:reqres_demo/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController email, password, confirmPassword;

  final GlobalKey<FormState> registerForm = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    password.dispose();
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register screen'),
        ),
        body: Form(
          key: registerForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome',
                  style: TextStyle(fontSize: 44),
                ),
                const SizedBox(
                  height: 22,
                ),
                const Text(
                  'Flutter rest Api login example',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 22,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return 'Email cannot be blank';
                    }
                  },
                  controller: email,
                  decoration: const InputDecoration(
                      hintText: 'email',
                      label: Text('email'),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return 'Password cannot be blank';
                    }
                  },
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'password',
                      label: Text('password'),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  validator: (value) {
                    if (value != password.text) {
                      return 'Password does not match';
                    }
                  },
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Confirm password',
                      label: Text('Confirm password'),
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (registerForm.currentState!.validate()) {
                          final data = await provider.post(
                              uri: Uri.parse(registerUrl),
                              body: {
                                'email': email.text.trim(),
                                'password': password.text.trim()
                              });
                          if (provider.requestSuccess) {
                            if (mounted) {
                              HomeScreen(data: data).launch(context,
                                  isNewTask: true,
                                  pageRouteAnimation: PageRouteAnimation.Slide);
                            }
                          } else {
                            toastError(data);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      child: provider.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Loader(
                                  size: 40,
                                ),
                                15.width,
                                const Text('Please wait')
                              ],
                            )
                          : const Text('Login')),
                ),
                10.height,
                Row(
                  children: [
                    const Text('Already have an account? '),
                    TextButton(
                        child: const Text('Login',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () => const LoginScreen().launch(context,
                            pageRouteAnimation: PageRouteAnimation.Slide))
                  ],
                )
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 20),
          ),
        ));
  }
}
