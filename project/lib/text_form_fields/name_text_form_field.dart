import 'package:flutter/material.dart';

class NameTextFormField extends StatelessWidget {
  const NameTextFormField({
    Key? key,
    required this.name,
  }) : super(key: key);

  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Name',
        prefixIcon: Icon(
          Icons.account_box,
          color: Color(0xFF1B5E20),
          )
      ),
      controller: name,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (name){
        if (name!.isEmpty){
          return 'Name is required';
        } else if (name.length < 4){
          return "This name is too short (minimum 4 characters)";
        } else {
          return null;
        }
      },
    );
  }
}