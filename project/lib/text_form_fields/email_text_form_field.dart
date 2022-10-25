import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  const EmailTextFormField({
    Key? key,
    required this.email,
  }) : super(key: key);

  final TextEditingController email;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Email address',
        prefixIcon: Icon(
          Icons.email,
          color: Color(0xFF1B5E20),
          )
      ),
      controller: email,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email){
        final regex = RegExp(r'\w+@\w+\.\w+');
        if (email!.isEmpty){
          return 'We need an email adress';
        } else if (!regex.hasMatch(email)){
          return "That doesn't look like an email adress";
        } else {
          return null;
        }
      },
    );
  }
}