import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  const PasswordTextFormField({
    Key? key,
    required this.password,
  }) : super(key: key);

  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.password,
          color: Color(0xFF1B5E20),
        ),
        hintText: 'Password',
      ),
      controller: password,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (password) {
        if(password!.length < 6) {
          return "Password is too short (minimum 6 characters)";
        } else {
          return null;
        }
      },
    );
  }
}