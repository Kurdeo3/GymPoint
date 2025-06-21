import 'package:flutter/material.dart';
import 'package:flutter_application_tugasbesar/View/login.dart';
import 'package:flutter_application_tugasbesar/view/register.dart';
import 'package:flutter_application_tugasbesar/view/home.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class OptionMenu extends StatelessWidget {
  const OptionMenu({Key? key}): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    bool isSkipped = false;
    return Scaffold(
        backgroundColor: Colors.grey[600],
        body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/TB_logo.png',
            ),

            Container(
              width: 300,
                child: ElevatedButton(
                  child: NeumorphicText(
                    'Login',
                    style: NeumorphicStyle(
                      depth: 1,
                      color: Colors.black
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.white, width: 3),
                        ),
                  ),
                ),
            ),

            SizedBox(height: 20),
            Container(
              width: 300,
                child: ElevatedButton(
                  child: NeumorphicText(
                    'Register',
                    style: NeumorphicStyle(
                      depth: 1,
                      color: Colors.black
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterView()),
                    );
                  },
                  style:ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.grey, width: 3),
                        )
                  ),
                ),
            ),

            SizedBox(height: 10),
            TextButton(
              child: NeumorphicText(
                    'Lewati',
                    style: NeumorphicStyle(
                      depth: 2,
                      color: Colors.white,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                ),
              ),
              onPressed: (){
                isSkipped = true;
                Map<String, dynamic> emptyFormData = {
                  'username': '',
                  'password': '',
                  'nama': '',
                  'umur': '',
                  'jenisKelamin': '',
                  'email': '',
                  'notelp': '',
                };

                Navigator.push(
                context, 
                MaterialPageRoute(
                    builder: (_) => HomeView(formData: (emptyFormData))));
              },
            ),
          ],
        ),
      ),
      ),
    ),
  );
}
}
