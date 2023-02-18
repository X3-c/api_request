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
  final String username;
  final String phone;
  final String website;
  const Users(
      {required this.email,
      required this.name,
      required this.username,
      required this.phone,
      required this.website});
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        email: json['email'],
        name: json['name'],
        username: json['username'],
        phone: json['phone'],
        website: json['website']);
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

  var searchString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: FutureBuilder<List<Users>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return snapshot.data![index].name
                                .toLowerCase()
                                .contains(searchString)
                            ? Card(
                                elevation: 4,
                                child: ExpansionTile(
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  title: Text(
                                    snapshot.data![index].name,
                                    style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(snapshot.data![index].email),
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Username: ${snapshot.data![index].username}',
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Website: ${snapshot.data![index].website}',
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Phone: ${snapshot.data![index].phone}',
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("Error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text("Getting Data..");
                }
                return const CircularProgressIndicator();
              },
            ))
          ],
        ),
      ),
    );
  }
}
