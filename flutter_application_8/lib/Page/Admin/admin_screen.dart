import 'package:flutter/material.dart';
import 'package:flutter_application_8/Page/Admin/picture_screen.dart';
import 'package:flutter_application_8/Page/Admin/requisite_screen.dart';
import 'package:flutter_application_8/Page/Admin/teacherCategory_screen.dart';
import 'package:flutter_application_8/Page/Admin/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../User/use_screen.dart';
import 'groupType_screen.dart'; // Импорт страницы GroupType

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Панель админа'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Список таблиц',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('GroupType'), // Имя страницы GroupType
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupTypeScreen()), // Переход на страницу GroupType
                );
              },
            ),
            ListTile(
              title: Text('TeacherCategory'), // Имя страницы TeacherCategory
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherCategoryScreen()), // Переход на страницу GroupType
                );
              },
            ),
            ListTile(
              title: Text('Picture'), // Имя страницы Picture
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PictureScreen()), // Переход на страницу GroupType
                );
              },
            ),
            ListTile(
              title: Text('Requisite'), // Имя страницы Picture
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RequisiteScreen()), // Переход на страницу GroupType
                );
              },
            ),
            ListTile(
              title: Text('User'), // Имя страницы Picture
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersScreen()), // Переход на страницу GroupType
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 0, // Замените 0 на количество элементов вашего списка
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Удаление токена из SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Удаляем токен

    // Переход на экран входа
    Navigator.pushReplacementNamed(context, '/login');
  }
}
