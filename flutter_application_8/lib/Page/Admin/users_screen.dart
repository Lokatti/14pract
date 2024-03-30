import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_8/Models/User.dart';
import 'package:flutter_application_8/services/api_service.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<User>> futureUsers;
  late final Dio dio;
  late final ApiService apiService;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);
    futureUsers = apiService.getUsers();
  }

  void _refreshUsers() {
    setState(() {
      futureUsers = apiService.getUsers();
    });
  }

  void _refreshPage() {
    _refreshUsers();
  }

  void _showAddUserDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить нового пользователя'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Фамилия'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String email = emailController.text;

                User newUser = User(
                  usersId: 0, // Предполагается, что идентификатор генерируется автоматически на сервере
                  firstName: firstName,
                  lastName: lastName,
                  email: email,
                  password: '', // Для примера, вы можете доработать эту часть, если требуется отправка пароля
                  role: 'user', // Для примера, вы можете изменить роль по умолчанию
                );

                bool success = await apiService.addUser(newUser);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Пользователь успешно добавлен')),
                  );
                  Navigator.of(context).pop();
                  _refreshUsers();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Не удалось добавить пользователя')),
                  );
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователи'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  title: Text('ID: ${user.usersId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Имя: ${user.firstName} ${user.lastName}'),
                      Text('Email: ${user.email}'),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Нет данных'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
