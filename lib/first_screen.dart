import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_7/users_model.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  get url_ => 'https://randomuser.me/api/?results=20';

  List<UserModel> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Users'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pictureURL),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
            
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetch,
        child: Icon(Icons.refresh),
      ),
    );
  }

  void fetch() async {
    final uri = Uri.parse(url_);
    final response = await http.get(uri);

    String body = '';

    if (response.statusCode == 200) {
      body = response.body;
      print(body);

      final json_data = jsonDecode(body);

      final results = json_data['results'] as List<dynamic>;
      final converted =
          results.map((user) => UserModel.fromJson(user)).toList();

      setState(() {
        users = converted;
      });
    }
  }
}
