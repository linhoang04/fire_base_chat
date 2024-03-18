import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const UserTitle({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            //icon
            const Icon(Icons.person),
            //username
            Text(text),
          ],
        ),
      ),
    );
  }
}
