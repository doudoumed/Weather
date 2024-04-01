// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);
  final Widget icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: IconButton(
        onPressed: onPressed,
        constraints: const BoxConstraints.tightFor(width: 40),
        color: Colors.white,
        icon: icon,
        splashRadius: 22,
      ),
    );
  }
}
