import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_tugasbesar/View/login.dart';
import 'package:flutter_application_tugasbesar/component/form_component.dart';
import 'package:flutter_application_tugasbesar/view/Entity/User.dart';
import 'package:flutter_application_tugasbesar/view/Client/UserClient.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController umurController = TextEditingController();

  String? selectedJenisKelamin;
  final List<String> jenisKelaminOption = ['Laki-laki', 'Perempuan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          iconSize: 50,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[600],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Image.asset(
                'images/TB_logo.png',
                width: 150,
                height: 150,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  margin: const EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "REGISTER",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Nama Tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: namaController,
                            hintTxt: "Nama",
                            helperTxt: "Nama Panjang",
                            iconData: Icons.face,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Umur Tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: umurController,
                            hintTxt: "Umur",
                            helperTxt: "Masukkan umur anda",
                            iconData: Icons.numbers,
                          ),
                          inputDropdown(
                            (value) {
                              if (value == null) {
                                return 'Jenis Kelamin Tidak boleh kosong';
                              }
                              return null;
                            },
                            hintTxt: "Jenis Kelamin",
                            helperTxt: "Pilih jenis kelamin",
                            iconData: Icons.male,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Username Tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: usernameController,
                            hintTxt: "Username",
                            helperTxt: "Masukkan Username",
                            iconData: Icons.person,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Email Tidak boleh kosong';
                              }
                              if (!p0.contains('@')) {
                                return 'Email Harus menggunakan @';
                              }
                              return null;
                            },
                            controller: emailController,
                            hintTxt: "Email",
                            helperTxt: "email@gmail.com",
                            iconData: Icons.email,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Password Tidak boleh kosong';
                              }
                              if (p0.length < 5) {
                                return 'Password minimal 5 digit';
                              }
                              return null;
                            },
                            controller: passwordController,
                            hintTxt: "Password",
                            helperTxt: "xxxxx",
                            iconData: Icons.password,
                            password: true,
                          ),
                          inputForm(
                            (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return 'Nomor Telepon Tidak boleh kosong';
                              }
                              return null;
                            },
                            controller: notelpController,
                            hintTxt: "No Telp",
                            helperTxt: "081234567890",
                            iconData: Icons.phone_android,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User user = User(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  nama: namaController.text,
                                  umur: int.tryParse(umurController.text) ?? 0,
                                  jenisKelamin: selectedJenisKelamin ?? '',
                                  email: emailController.text,
                                  noTelp: notelpController.text,
                                );

                                try {
                                  
                                  await UserClient.create(user);

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Register Berhasil"),
                                        content: Text("Selamat Kamu Berhasil Register"),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => LoginView(),
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Register Gagal"),
                                        content: Text("Terjadi kesalahan saat register: $e"),
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
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Simpan'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding inputDropdown(
    Function(String?) validasi, {
    required String hintTxt,
    required String helperTxt,
    required IconData iconData,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        width: 350,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hintTxt,
            helperText: helperTxt,
            prefixIcon: Icon(iconData),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 3),
            ),
          ),
          value: selectedJenisKelamin,
          items: jenisKelaminOption.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedJenisKelamin = newValue;
            });
          },
          validator: (value) => validasi(value),
        ),
      ),
    );
  }
}
