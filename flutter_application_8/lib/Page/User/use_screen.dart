import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'User Screen Content',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Удаление токена из SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    // Переход на экран входа
    Navigator.pushReplacementNamed(context, '/login');
  }
}
