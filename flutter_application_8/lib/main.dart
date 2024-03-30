import 'package:flutter/material.dart';
import 'package:flutter_application_8/Page/Admin//groupType_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Page/Admin/admin_screen.dart';
import 'Page/Admin/picture_screen.dart';
import 'Page/Admin/requisite_screen.dart';
import 'Page/Admin/teacherCategory_screen.dart';
import 'Page/Admin/users_screen.dart';
import 'Page/login_screen.dart';
import 'Page/register_screen.dart';
import 'Page/User/use_screen.dart';
import 'services/service_locator.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Убедимся, что инициализация завершена
  setupLocator();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('auth_token');
  final String? role = prefs.getString('role'); // Получаем role
  runApp(MyApp(authToken: authToken, role: role)); // Передаем в MyApp
}

class MyApp extends StatelessWidget {
  final String? authToken;
  final String? role;

  MyApp({required this.authToken, required this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String?>(
        future: determineInitialRoute(authToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data != null && role != null) {
            if (role == 'Admin') {
              return AdminScreen();
            } else if (role == 'User') {
              return UseScreen();
            }
          }
          return LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/admin': (context) => AdminScreen(),
        '/user': (context) => UseScreen(),
        '/groupType': (context) => GroupTypeScreen(),
        '/teacherCategory': (context) => TeacherCategoryScreen(),
        '/picture': (context) => PictureScreen(),
        '/requisite': (context) => RequisiteScreen(),
        '/users': (context) => UsersScreen(),
      },
    );
  }

  static Future<String?> determineInitialRoute(String? authToken) async {
    return authToken;
  }
}
