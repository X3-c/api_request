import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Users>> fetchUser(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((p) => Users.fromJson(p))
        .toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class Users {
  final String email;
  final String name;
  const Users({required this.email, required this.name});
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(email: json['email'], name: json['name']);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Users>>? futureUser;
  @override
  void initState() {
    super.initState();

    // ...
    futureUser = fetchUser(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Users>>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(snapshot.data![index].email),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Text("Error");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Getting Data...");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
