import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget{
  
  final String error;

  const ErrorText({
    Key? key,
    required this.error
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Flex(
        direction: Axis.vertical,
        children: [
          const Icon(
            Icons.cancel_sharp,
            color: Colors.red,
          ),
          Text(
            error,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red  
            ),
          ),
        ],
      ),
    );
  }
}