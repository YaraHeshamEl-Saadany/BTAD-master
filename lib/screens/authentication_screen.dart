import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:string_capitalize/string_capitalize.dart';

// Helper imports
import 'package:btad/helpers/firebase_helper.dart';

List<String> accountRoles = [
  'admin',
  'doctor',
  'patient',
];

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  // Form parameters
  final _formKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  late String _enteredEmail;
  late String _enteredPassword;
  late String _firstName;
  late String _lastName;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _resetPasswordController = TextEditingController();

  bool _passwordIsVisible = false;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _resetPasswordController.addListener(() => setState(() {}));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    bool isValid = _resetFormKey.currentState!.validate();
    if (!isValid) return;
    try {
      auth.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      setState(() {
        _resetPasswordController.clear();
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An email has been sent to $email"),
          duration: const Duration(seconds: 5),
        ),
      );
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  // Authentication
  bool _isAuthenticating = false;
  Future<void> _authenticate() async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) return;
    // Trigger loading spinner by flagging the authentication boolean
    setState(() {
      _isAuthenticating = true;
    });
    if (!_isLogin) {
      await signUp(
        firstName: _firstName,
        lastName: _lastName,
        email: _enteredEmail,
        password: _enteredPassword,
        role: _currentRole,
        context: context,
      );
      setState(() => _isAuthenticating = false);
    } else {
      await signIn(
        email: _enteredEmail,
        password: _enteredPassword,
        context: context,
      );
    }
    setState(() => _isAuthenticating = false);
  }

  String _currentRole = accountRoles[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          !_isLogin ? "Sign Up" : "Sign In",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 256,
                  margin: const EdgeInsets.only(
                    top: 32,
                    bottom: 16,
                    left: 16,
                    right: 16,
                  ),
                  // child: FaIcon(
                  //   FontAwesomeIcons.person,
                  //   size: 256,
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                ),
                Card(
                  margin: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: _isAuthenticating,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        suffix: _firstNameController
                                                .text.isNotEmpty
                                            ? IconButton(
                                                onPressed: !_isAuthenticating
                                                    ? () => _firstNameController
                                                        .clear()
                                                    : null,
                                                icon: const FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                ),
                                              )
                                            : null,
                                        labelText: 'First Name',
                                      ),
                                      onChanged: (value) => _firstName =
                                          value.capitalize().trim(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a first name';
                                        }
                                        if (value.length < 2) {
                                          return 'Please enter at least 2 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: _isAuthenticating,
                                      controller: _lastNameController,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        suffix: _lastNameController
                                                .text.isNotEmpty
                                            ? IconButton(
                                                onPressed: !_isAuthenticating
                                                    ? () => _lastNameController
                                                        .clear()
                                                    : null,
                                                icon: const FaIcon(
                                                  FontAwesomeIcons.xmark,
                                                ),
                                              )
                                            : null,
                                        labelText: 'Last Name',
                                      ),
                                      onChanged: (value) =>
                                          _lastName = value.capitalize().trim(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a first name';
                                        }
                                        if (value.length < 2) {
                                          return 'Please enter at least 2 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            TextFormField(
                              readOnly: _isAuthenticating,
                              controller: _emailController,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                suffix: _emailController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: !_isAuthenticating
                                            ? () => _emailController.clear()
                                            : null,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.xmark,
                                        ),
                                      )
                                    : null,
                              ),
                              onChanged: (value) =>
                                  _enteredEmail = value.trim(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email address";
                                }
                                if (!EmailValidator.validate(value)) {
                                  return "Please enter a valid email address";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              readOnly: _isAuthenticating,
                              controller: _passwordController,
                              obscureText: !_passwordIsVisible,
                              decoration: InputDecoration(
                                suffix: _passwordController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: !_isAuthenticating
                                            ? () {
                                                setState(() {
                                                  _passwordIsVisible =
                                                      !_passwordIsVisible;
                                                });
                                              }
                                            : null,
                                        icon: !_passwordIsVisible
                                            ? const FaIcon(FontAwesomeIcons.eye)
                                            : const FaIcon(
                                                FontAwesomeIcons.eyeSlash,
                                              ),
                                      )
                                    : null,
                                labelText: 'Password',
                              ),
                              onChanged: (value) => _enteredPassword = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Please enter at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_isLogin)
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Form(
                                          key: _resetFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: TextFormField(
                                                  readOnly: _isAuthenticating,
                                                  controller:
                                                      _resetPasswordController,
                                                  autocorrect: false,
                                                  textCapitalization:
                                                      TextCapitalization.none,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration: InputDecoration(
                                                    labelText: 'Email Address',
                                                    suffix:
                                                        _resetPasswordController
                                                                .text.isNotEmpty
                                                            ? IconButton(
                                                                onPressed: !_isAuthenticating
                                                                    ? () => _resetPasswordController
                                                                        .clear()
                                                                    : null,
                                                                icon:
                                                                    const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .xmark,
                                                                ),
                                                              )
                                                            : null,
                                                  ),
                                                  onChanged: (value) =>
                                                      _enteredEmail =
                                                          value.trim(),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter your email address";
                                                    }
                                                    if (!EmailValidator
                                                        .validate(value)) {
                                                      return "Please enter a valid email address";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  sendPasswordResetEmail(
                                                    _enteredEmail,
                                                  );
                                                },
                                                child: const Text("Send Email"),
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "I forgot my password",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            if (!_isLogin)
                              Column(
                                children: [
                                  const SizedBox(height: 8),
                                  Column(
                                    children: [
                                      RadioListTile(
                                        value: accountRoles[0],
                                        groupValue: _currentRole,
                                        title: Text(
                                          accountRoles[0].capitalize(),
                                        ),
                                        onChanged: !_isAuthenticating
                                            ? (value) {
                                                setState(() {
                                                  _currentRole =
                                                      value.toString();
                                                });
                                              }
                                            : null,
                                      ),
                                      RadioListTile(
                                        value: accountRoles[1],
                                        groupValue: _currentRole,
                                        onChanged: !_isAuthenticating
                                            ? (value) {
                                                setState(() {
                                                  _currentRole =
                                                      value.toString();
                                                });
                                              }
                                            : null,
                                        title: Text(
                                          accountRoles[1].capitalize(),
                                        ),
                                      ),
                                      RadioListTile(
                                        value: accountRoles[2],
                                        groupValue: _currentRole,
                                        onChanged: !_isAuthenticating
                                            ? (value) {
                                                setState(() {
                                                  _currentRole =
                                                      value.toString();
                                                });
                                              }
                                            : null,
                                        title: Text(
                                          accountRoles[2].capitalize(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            !_isLogin
                                ? const SizedBox(height: 8)
                                : const SizedBox(height: 16),
                            !_isAuthenticating
                                ? Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: _authenticate,
                                        child: Text(
                                          !_isLogin ? "Sign Up" : "Sign In",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = !_isLogin;
                                            setState(() {
                                              _formKey.currentState!.reset();
                                              _emailController.clear();
                                              _passwordController.clear();
                                            });
                                          });
                                        },
                                        child: Text(
                                          !_isLogin
                                              ? "I already have an account"
                                              : "I don't have an account",
                                        ),
                                      ),
                                    ],
                                  )
                                : const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
