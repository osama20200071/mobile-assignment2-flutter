import 'package:first_app/services/context/AuthContext.dart';
import 'package:first_app/views/UI/nav.dart';
import 'package:first_app/views/login_screen.dart';
import 'package:first_app/views/register_screen.dart';
// import 'package:first_app/with-api/LoginScreen.dart';
import 'package:first_app/with-api/AllStoresScreen.dart';
import 'package:first_app/with-api/FavStores.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => const NavBar(),
          "/login": (context) => const LoginScreen(),
          "/stores": (context) => StoreListScreen(),
          '/register': (context) => const RegisterScreen(),
          '/fav-stores': (context) => FavStoresScreen(),
        },
      ),
    );
  }
}
