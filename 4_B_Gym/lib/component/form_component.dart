import 'package:flutter/material.dart';


Padding inputForm(Function(String?) validasi, {required TextEditingController controller,
required String hintTxt,required String helperTxt,required IconData iconData, bool password = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        width: 350,
        child : TextFormField(
              validator: (value) => validasi(value),
              autofocus: true,
              controller: controller,
              obscureText: password,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: hintTxt,
                helperText: helperTxt,
                prefixIcon : Icon(iconData),
                fillColor: Colors.white,
                filled: true,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                )
              ),
            )
      ),
    );
}