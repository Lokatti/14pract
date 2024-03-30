import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Для использования регулярных выражений
import '../Models/LoginRequest.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void onLoginButtonPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Проверяем наличие пробелов в почте и пароле
      RegExp regExp = RegExp(r"\s"); // Регулярное выражение для поиска пробелов
      if (regExp.hasMatch(email) || regExp.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Почта и пароль не должны содержать пробелы'),
          ),
        );
        return; // Завершаем функцию, чтобы избежать выполнения запроса
      }

      // Допустим, ApiService уже инжектирован через GetIt или другим способом
      bool token = await getIt<ApiService>().login(email, password);

      if (token != false) {
        print("Успешная авторизация, токен: $token");

        // Получаем тип пользователя из SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        String? role = prefs.getString('role');

        if (role == 'Admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (role == 'User') {
          Navigator.pushReplacementNamed(context, '/user');
        } else {
          print("Неизвестный тип пользователя: $role");
        }
      } else {
        // Показываем сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Неверная почта или пароль'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
        centerTitle: true, // Центрирование заголовка
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Введите почту',
                  border: OutlineInputBorder(), // Границы текстового поля
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите почту';
                  }
                  if (value.contains(' ')) {
                    return 'Почта не должна содержать пробелы';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25.0), // Промежуток между полями
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Введите пароль',
                  border: OutlineInputBorder(), // Границы текстового поля
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите пароль';
                  }
                  if (value.contains(' ')) {
                    return 'Пароль не должен содержать пробелы';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Промежуток между полями
              ElevatedButton(
                onPressed: () => onLoginButtonPressed(context),
                child: Text('Войти'),
              ),
              SizedBox(height: 8.0), // Промежуток между кнопками
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('К регистрации'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
