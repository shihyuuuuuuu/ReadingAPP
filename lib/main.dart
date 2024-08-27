import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/firebase_options.dart';
import 'package:reading_app/service/authentication.dart';
import 'package:reading_app/service/navigation.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Defer the first frame until `FlutterNativeSplash.remove()` is called
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);


  runApp( StreamBuilder<bool>(
    // Rebuild when login / logout
    stream: AuthenticationService().authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.active) {
        return const SizedBox.shrink();
      }
      if (snapshot.hasError) {
        debugPrint('Auth Error: ${snapshot.error}');
      }
      FlutterNativeSplash.remove();
      log('Auth state changed to ${snapshot.data}');

      return MyApp(key: ValueKey(snapshot.data));
    },
  )
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NavigationService>(create: (_) => NavigationService()),
        Provider<AuthenticationService>(create: (_) => AuthenticationService()),
      ], 
      child: MaterialApp.router(
        title: 'Reading APP',
        theme: const MaterialTheme().light(),
        darkTheme: const MaterialTheme().dark(),
        themeMode: ThemeMode.light,
        routerConfig: router,
        restorationScopeId: 'app',
      )
    );
  }
}
