import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:reading_app/data/models/user.dart';
import 'package:reading_app/service/authentication.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  String _userPasswordCheck = '';

  TextEditingController _passwordController = TextEditingController();
  var _isAuthenticating = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "chat\nnote", 
                  style: textTheme.displayMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  !_isLogin
                  ? TextFormField(
                    key: const ValueKey('name'),
                      decoration: const InputDecoration(
                          labelText: '使用者名稱'),
                      enableSuggestions: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 4) {
                          return '名稱至少四個字';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                  )
                  : SizedBox(),
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration: const InputDecoration(
                        labelText: 'Email Address'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return '必須輸入email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration:
                        const InputDecoration(labelText: '密碼'),
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().length < 6) {
                        return '密碼至少6個英文或數字';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  !_isLogin
                  ? TextFormField(
                    key: const ValueKey('passwordCheck'),
                    decoration:
                        const InputDecoration(labelText: '確認密碼'),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return '與密碼不符';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPasswordCheck = value!;
                    },
                  )
                  : const SizedBox(),
                  const SizedBox(height: 10),
                  
                  if (_isAuthenticating)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (!_isAuthenticating) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? '登入' : '註冊'),
                        ),
                      ),
                      if (_isLogin) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _logInWithGoogle,
                            icon: SvgPicture.asset(
                              'assets/images/logo_google.svg',
                              height: 20.0,
                              width: 20.0,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              foregroundColor: Colors.white,
                            ),
                            label: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Log in with Google'),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(_isLogin
                              ? '建立新帳號'
                              : '已有帳號'),
                        ),
                      ),
                    ],
                  ]
                ),
            )
          ]
        )
      )
    );
  }

  void _submit () async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();
    
    final authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    
    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        await authenticationService.logIn(
          email: _userEmail,
          password: _userPassword,
        );
      } else {
        await authenticationService.signUp(
          context: context,
          email: _userEmail,
          password: _userPassword,
          name: _userName,
        );
      }

      if (mounted) {
        setState(() {
          _isAuthenticating = false;
          if (!_isLogin){
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("註冊成功！"),
                duration: Duration(seconds: 2),
              )
            );
          }
        });
      }
    } catch (error) {
      debugPrint('Authentication failed with error: $error');
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
    }
  }

  
  void _logInWithGoogle() async {
    final authenticationService =
        Provider.of<AuthenticationService>(context, listen: false);
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await authenticationService.logInWithGoogle(context);

      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    } catch (error) {
      debugPrint('Google Sign-in failed with error: $error');
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-in failed with error: $error'),
          ),
        );
      }
    }
  }
}