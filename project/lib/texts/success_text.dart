import 'package:flutter/material.dart';

class SuccessText extends StatelessWidget{
  
  final String success;

  const SuccessText({
    Key? key,
    required this.success
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Flex(
        direction: Axis.vertical,
        children: [
          const Icon(
            Icons.check,
            color: Colors.green,
          ),
          Text(
            success,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green  
            ),
          ),
        ],
      ),
    );
  }
}