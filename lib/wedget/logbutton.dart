import 'package:flutter/material.dart';

class LogButton extends StatelessWidget {
  void Function()? onPressed;
  final String label;
  LogButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
          width: double.infinity,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          )),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Colors.blue,
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
