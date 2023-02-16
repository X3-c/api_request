import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<dynamic> users = [];

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // ...
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final email = user['email'];
            final name = user['name'];
            final username = user['username'];
            final phone = user['phone'];
            final website = user['website'];
            final street = user['address']['street'];
            return Card(
              color: const Color.fromRGBO(64, 66, 88, 1),
              elevation: 4,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                expandedCrossAxisAlignment: CrossAxisAlignment.end,
                title: Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Website: $website',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Username: $username',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Street: $street',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Phone: $phone',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void fetchUsers() async {
    const url = "https://jsonplaceholder.typicode.com/users";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json;
    });
  }
}
