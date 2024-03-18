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
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            //icon
            const Icon(Icons.person),
            const SizedBox(
              width: 20,
            ),
            //username
            Text(text),
          ],
        ),
      ),
    );
  }
}
