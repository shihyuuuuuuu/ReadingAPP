import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reading_app/data/local/login_method.dart';
import 'package:reading_app/data/models/user.dart' as models;
import 'package:reading_app/data/repositories/user_repo.dart';

class AuthenticationService {
  final UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationService({UserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  /// Returns the user ID.
  Future<String?> signUp(
      {required BuildContext context,
      required String email,
      required String password,
      required String name }) async {
    try {
      // 
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = credential.user!.uid;
      _postSingUp(
        userId: userId,
        email: email,
        name: name,
        logInMethods: [LogInMethod.emailAndPassword],
      );

      debugPrint('New email account created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  /// Param `avatarUrl` and `avatarFile` cannot be both `null`.
  Future<void> _postSingUp({
    required String userId,
    required String email,
    required name,
    String? avatarUrl,
    required List<LogInMethod> logInMethods,
  }) async {
    
   
    models.User user = models.User(
      id: userId,
      name: name, 
      email: email, 
      avatarUrl: avatarUrl,
      logInMethods: logInMethods 
    );

    await _userRepository.createUser(user);
  }

  // Returns the user ID.
  Future<String> logIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // _postLogIn(userCredential.user!);

      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('帳號或密碼錯誤');
      }
      throw Exception('${e.code}: ${e.message}');
    }  
}
  
  /// Returns the user ID or `null` in case the log in process was aborted.
  Future<String?> logInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Return null if the user cancels the sign-in process
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if the email is already associated with an email account
      final googleEmail = googleUser.email;
      final existingUserDoc = await _userRepository.getUserByEmail(googleEmail);

      if (!context.mounted) return null;

      late User user;
      if (existingUserDoc == null) {
        // Email is not associated with any existing account, so create a new account
        user =
            (await _firebaseAuth.signInWithCredential(googleCredential)).user!;

        _postSingUp(
          userId: user.uid,
          email: googleEmail,
          name: googleUser.displayName ?? googleEmail.split('@').first,
          avatarUrl: googleUser.photoUrl ?? 'https://via.placeholder.com/150',
          logInMethods: [LogInMethod.google],
        );
        debugPrint('New Google account created');
      } else {
        if (!existingUserDoc.logInMethods.contains(LogInMethod.google)) {
          // Email is already associated with an email account, so link it with the Google credential
          final password = await _promptLinkGoogleToEmail(context, googleEmail);
          if (password == null) {
            return null; // User cancelled the password prompt
          }

          user = (await _firebaseAuth.signInWithEmailAndPassword(
            email: googleEmail,
            password: password,
          ))
              .user!;

          // Link the Google credential to the existing email account
          await user.linkWithCredential(googleCredential);
          debugPrint(
              'Google account linked to existing email account: $googleEmail');

          _postSingUp(
            userId: user.uid,
            email: googleEmail,
            name: existingUserDoc.name, // No overwrite
            avatarUrl: existingUserDoc.avatarUrl, // No overwrite
            logInMethods: [LogInMethod.emailAndPassword, LogInMethod.google],
          );
        } else {
          // Email account is already linked, proceed log in
          user = (await _firebaseAuth.signInWithCredential(googleCredential))
              .user!;
        }
      }

      // _postLogIn(user);

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    }
  }

  Future<String?> _promptLinkGoogleToEmail(
      BuildContext context, String email) async {
    TextEditingController passwordController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email already in use'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  children: [
                    const TextSpan(
                        text: 'The email address of your Google account:\n\n'),
                    TextSpan(
                      text: email,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '\n\nhas already been used by an email account. To proceed, please log into the email account to link it with this Google account.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(passwordController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logOut() async {
    if (GoogleSignIn().currentUser != null) {
      await GoogleSignIn().signOut();
    }

    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      log('failed to disconnect on signout');
    }

    await _firebaseAuth.signOut();
  }

  /// Returns the user ID or `null` if the user is not logged in.
  String? checkAndGetLoggedInUserId() {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    user.reload();
    return _firebaseAuth.currentUser?.uid; // return new result
  }

  /// Returns a stream of boolean values indicating whether the user is logged in or not
  Stream<bool> authStateChanges() {
    return _firebaseAuth.idTokenChanges().map((user) => user != null);
  }
}
