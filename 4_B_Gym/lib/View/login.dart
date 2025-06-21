import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/View/home.dart';
import 'package:flutter_application_tugasbesar/View/register.dart';
import 'package:flutter_application_tugasbesar/View/optionMenu.dart';
import 'package:flutter_application_tugasbesar/component/form_component.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';

class LoginView extends StatefulWidget {
  final Map<String, dynamic>? data;

  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataForm = widget.data ?? {};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          iconSize: 50,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OptionMenu(),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            Image.asset(
              'images/TB_logo.png',
              width: 150,
              height: 150,
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 550,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Username tidak boleh kosong";
                              }
                              return null;
                            },
                            controller: usernameController,
                            hintTxt: "Username",
                            helperTxt: "Inputkan User yang telah didaftar",
                            iconData: Icons.person,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              return null;
                            },
                            password: true,
                            controller: passwordController,
                            hintTxt: "Password",
                            helperTxt: "Inputkan Password",
                            iconData: Icons.password,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final loginResult = await UserClient.login(
                                  usernameController.text,
                                  passwordController.text,
                                );

                                final user = loginResult['detail'];
                                final token = loginResult['token'];
                                dataForm['username'] = user['username'];
                                dataForm['token'] = token;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Login Berhasil"),
                                      content: Text("Selamat Kamu berhasil login"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => HomeView(formData: dataForm),
                                              ),
                                            );
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } catch (e) {
                                print('Error saat login: $e');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Login Gagal"),
                                      content: Text(e.toString()),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  pushRegister(context);
                                },
                                child: const Text(
                                  'Don\'t have an account? Register here!',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}