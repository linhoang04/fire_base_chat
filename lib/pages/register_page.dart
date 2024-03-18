import 'package:app_chat/components/my_button.dart';
import 'package:app_chat/components/my_text_field.dart';
import 'package:app_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final Function()? onTap;
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passTextController = TextEditingController();
  final TextEditingController _confirmTextController = TextEditingController();
  RegisterPage({super.key, required this.onTap});
  void register(BuildContext context) {
    //user register
    final auth = AuthService();
    //password match --> create user
    if (_passTextController.text == _confirmTextController.text) {
      try {
        auth.signUpWithEmailPassword(
          _emailTextController.text,
          _passTextController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
    //password don't match --> show error user
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text(
            "Password don't match",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 25,
            ),
            //wwelcomeback messesage
            Text(
              'Register app messesage',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(
              height: 25,
            ),
            //email textField
            MyTextField(
              hintext: 'Email',
              obscureText: false,
              controller: _emailTextController,
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              hintext: 'PassWord',
              obscureText: true,
              controller: _passTextController,
            ),
            const SizedBox(
              height: 15,
            ),
            MyTextField(
              hintext: 'Confirm PassWord',
              obscureText: true,
              controller: _confirmTextController,
            ),
            const SizedBox(
              height: 25,
            ),
            //login
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 25,
            ),
            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
