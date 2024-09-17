import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/service/authentication.dart';
import 'package:reading_app/service/navigation.dart';
import 'package:reading_app/service/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context, listen: false);
    final nav = Provider.of<NavigationService>(context, listen: false);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Home Page'),
        FilledButton(
          onPressed: () {
            authService.logOut();
            // nav.goLogin();
          },
          child: const Text("Log out"),
        )
      ],
    );
  }
}
