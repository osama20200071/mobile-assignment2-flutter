import 'package:first_app/models/FavStore.dart';

import 'package:first_app/services/context/AuthContext.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FavStoresScreen extends StatefulWidget {
  @override
  _FavStoreScreenState createState() => _FavStoreScreenState();
}

class _FavStoreScreenState extends State<FavStoresScreen> {
  late List<FavStore> stores = [];
  bool dataLoaded = false;
  late List<bool> lovedStates; // List to store love button states

  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == "") {
      debugPrint("No token");
      Navigator.pushNamed(context, '/login');
    } else {
      fetchFavStores();
    }
  }

  Future<void> fetchFavStores() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    print("================ token: $token");
    const String apiUrl = 'http://10.0.2.2:3000/stores/fav-stores';
    final response = await http.get(
      Uri.parse("$apiUrl?lat=30&lon=31.25"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Specify JSON content type
      },
    ); // Encode the body to JSON

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        dataLoaded = true;
      });
      setState(() {
        stores = (jsonData['favStores'] as List)
            .map((storeJson) => FavStore.fromJson(storeJson))
            .toList();
      });
      setState(() {
        lovedStates = List<bool>.filled(
            stores.length, true); // Initialize with false values
      });
    } else {
      throw Exception('Failed to load stores');
    }
  }

  Future<void> removeFromFavorites(String id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    const String apiUrl = 'http://10.0.2.2:3000/stores/fav-stores';
    final response = await http.delete(
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
      print("store $id removed from favStores");
    } else {
      // Handle login failure
    }
  }

  void _onLoveButtonPressed(int index, String storeId) {
    setState(() {
      lovedStates[index] = !lovedStates[index];
    });
    removeFromFavorites(storeId);
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
