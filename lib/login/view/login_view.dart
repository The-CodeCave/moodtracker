import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFE6E5DE),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                'login_logo_complete.png',
              ),
            ),
            const SizedBox.square(dimension: 24),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'E-Mail',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
