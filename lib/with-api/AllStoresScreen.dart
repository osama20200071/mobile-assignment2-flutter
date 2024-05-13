import 'dart:async';
import 'package:first_app/models/store.dart';
import 'package:first_app/services/context/AuthContext.dart';
import 'package:first_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class StoreListScreen extends StatefulWidget {
  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  late List<Store> stores = [];
  bool dataLoaded = false;
  late List<bool> lovedStates; // List to store love button states

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == "") {
      debugPrint("No token");
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _navigateToNextScreen();
      });
      // Navigator.pushNamed(context, '/login');
    } else {
      fetchStores();
    }
  }

  void _navigateToNextScreen() {
    // Perform navigation to the next screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<void> fetchStores() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    const String apiUrl = 'http://10.0.2.2:3000/stores';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        dataLoaded = true;
      });
      setState(() {
        stores = (jsonData['stores'] as List)
            .map((storeJson) => Store.fromJson(storeJson))
            .toList();
      });
      setState(() {
        lovedStates = List<bool>.filled(
            stores.length, false); // Initialize with false values
      });
    } else {
      throw Exception('Failed to load stores');
    }
  }

  Future<void> addToFavorites(String id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    const String apiUrl = 'http://10.0.2.2:3000/stores/fav-stores';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
        'storeId': id,
      }),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      debugPrint("store $id added to favStores");
    } else {
      // Handle login failure
    }
  }

  void _onLoveButtonPressed(int index, String storeId) {
    setState(() {
      lovedStates[index] = !lovedStates[index];
    });
    addToFavorites(storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Stores', style: TextStyle(fontSize: 20)),
      ),
      body: stores.isEmpty
          ? Center(
              child: !dataLoaded
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : Text('No stores found'),
            )
          : ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(
                      store.name,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _onLoveButtonPressed(index, store.id);
                      },
                      icon: Icon(
                        lovedStates[index]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: lovedStates[index] ? Colors.red : null,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
