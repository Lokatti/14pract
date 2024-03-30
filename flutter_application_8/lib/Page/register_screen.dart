import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/service_locator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateButtonState);
    _lastNameController.addListener(_updateButtonState);
    _middleNameController.addListener(_updateButtonState);
    _ratingController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _ratingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final middleName = _middleNameController.text;
    final rating = _ratingController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isButtonEnabled = firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          middleName.isNotEmpty &&
          rating.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          !_containsDigits(firstName) &&
          !_containsDigits(lastName) &&
          !_containsDigits(middleName) &&
          _isNumeric(rating) && // Проверяем, что рейтинг состоит только из цифр
          !email.contains(' ');
    });
  }

  bool _containsDigits(String value) {
    return value.contains(RegExp(r'\d'));
  }

  bool _isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  void onRegisterButtonPressed() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String middleName = _middleNameController.text.trim();
    final int rating = int.tryParse(_ratingController.text.trim()) ?? 0;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String role = "User";

    if (email.contains(' ') || password.contains(' ')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка регистрации'),
          content: Text('Адрес электронной почты не должен содержать пробелы.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_containsDigits(firstName) ||
        _containsDigits(lastName) ||
        _containsDigits(middleName)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка регистрации'),
          content: Text('Имена не должны содержать цифры.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final bool success = await getIt<ApiService>().register(
      firstName,
      lastName,
      middleName,
      rating,
      email,
      password,
      role,
    );
    if (success) {
      print("Успешная регистрация");
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print("Ошибка регистрации");
      // Handle registration failure
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Фамилия',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _middleNameController,
                decoration: InputDecoration(
                  labelText: 'Отчество',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Рейтинг "ФИДЕ"',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Почта',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Пароль',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isButtonEnabled ? onRegisterButtonPressed : null,
                child: Text('Создать аккаунт'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
