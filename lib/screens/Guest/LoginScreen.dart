import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:recognition/screens/Guest/Guest.dart';
import 'package:recognition/screens/Guest/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSecret = true;
  String password = "";
  String email = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuestScreen(),
                  ),
                );
              },
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Sign in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                        onChanged: ((value) => setState(() {
                              email = value;
                            })),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: ((value) => setState(() {
                              password = value;
                            })),
                        obscureText: _isSecret,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Enter your password',
                          suffixIcon: InkWell(
                              onTap: () =>
                                  setState(() => _isSecret = !_isSecret),
                              child: Icon(!_isSecret
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                        ),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not registered yet?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text('Create an account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
