import 'package:first_app/services/api.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color primaryColor = Colors.blue;
  Color secondaryColor = Color(0xffebebef);

  void sigupUser(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      debugPrint(emailController.text.trim());
      debugPrint(passwordController.text.trim());
      Api.signup(context, nameController.text.trim(),
          emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: primaryColor,
      ),
      backgroundColor: secondaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password should be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 13.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      sigupUser(context);
                    },
                    child: Text('Register', style: TextStyle(fontSize: 18.0)),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Already have an account? Login',
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
