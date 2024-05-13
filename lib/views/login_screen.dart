import 'package:first_app/services/api.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color primaryColor = Colors.blue;
  Color secondaryColor = Color(0xffebebef);

  void loginUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      debugPrint(emailController.text.trim());
      debugPrint(passwordController.text.trim());
      Api.login(
          context, emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: secondaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => loginUser(context),
                    child:
                        const Text('Login', style: TextStyle(fontSize: 18.0)),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Don\'t have an account? Register',
                        style: TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
