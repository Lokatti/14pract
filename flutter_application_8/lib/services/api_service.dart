  import 'dart:ui';
  import 'dart:convert';
  import 'package:dio/dio.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_application_8/Models/GroupType.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../Models/LoginRequest.dart';
  import '../Models/RegisterRequest.dart';
  import '../Models/Requisite.dart';
  import '../Models/TeacherCategory.dart';
  import '../Models/User.dart';
  import '../Page/Admin//groupType_screen.dart';
  import 'package:flutter_application_8/Models/Picture.dart';

  String api = 'http://192.168.233.125:5000/api';

  String UserId = '';

  class ApiService {
    final Dio dio;

    ApiService(this.dio);

    Future<bool> login(String email, String password) async {
      final loginRequest = LoginRequest(email: email, password: password);
      try {
        final response = await dio.post(
          '$api/Users/login',
          data: loginRequest.toJson(),
        );
         if (response.statusCode == 200) {
          String token = response.data['token'];
          int userId = response.data['userId'];
          String role = response.data['role'];
          UserId = userId.toString();
          await _saveToken(token);
          await _saveUserId(userId.toString()); // Сохраняем ID пользователя как строку
          await _saveRole(role);
          return true;
        }

        return false;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<void> _saveUserId(String userId) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
    }

    Future<void> _saveRole(String role) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('role', role);
    }

    Future<void> _saveToken(String token) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    }

    Future<bool> register(String firstName, String lastName, String middleName, int rating, String email, String password, String role) async {
      final registerRequest = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        middleName: middleName,
        rating: rating,
        email: email,
        password: password,
        role: role
      );
      try {
        dio.options.connectTimeout = Duration(seconds: 5);
        final response = await dio.post(
          '$api/Users/register',
          data: registerRequest.toJson(),
        );
        return response.statusCode == 201; // Возвращает true, если пользователь успешно создан
      } catch (e) {
        print(e);
        return false;
      }
    }

    ///////таблицы

    /////////GroupType
    Future<List<GroupType>> getGroupTypes() async {
      final response = await dio.get('$api/GroupTypes');
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        List<GroupType> groupTypes = jsonResponse.map((groupType) => GroupType.fromJson(groupType)).toList();
        if (searchQuery.isNotEmpty) {
          groupTypes = groupTypes.where((groupType) => groupType.groupTypeName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        }
        return groupTypes;
      } else {
        throw Exception('Failed to load groupTypes from API');
      }
    }

    Future<bool> deleteGroupType(int groupTypeId) async {
      try {
        final response = await dio.delete('$api/GroupTypes/$groupTypeId');
        return response.statusCode == 200;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<bool> updateGroupType(GroupType groupType) async {
      try {
        final response = await dio.put('$api/GroupTypes/${groupType.groupTypeId}', data: groupType.toJson());
        return response.statusCode == 200;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<bool> addGroupType(String groupTypeName, String descriptionType) async {
      final response = await dio.post(
        '$api/GroupTypes',
        data: {
          'groupTypeName': groupTypeName,
          'descriptionType': descriptionType,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    }

  /////////TeacherCategory

    Future<List<TeacherCategory>> getTeacherCategories() async {
      try {
        final response = await dio.get('$api/TeacherCategories');
        if (response.statusCode == 200) {
          List jsonResponse = response.data;
          List<TeacherCategory> teacherCategories = jsonResponse.map((teacherCategory) => TeacherCategory.fromJson(teacherCategory)).toList();
          if (searchQuery.isNotEmpty) {
            teacherCategories = teacherCategories.where((teacherCategory) => teacherCategory.teacherCategoryName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
          }
          return teacherCategories;
        } else {
          throw Exception('Failed to load teacherCategory from API');
        }
      } catch (e) {
        print(e);
        throw Exception('Failed to load teacherCategory from API');
      }
    }

    Future<bool> deleteTeacherCategory(int teacherCategoryId) async {
      try {
        final response = await dio.delete('$api/TeacherCategories/$teacherCategoryId');
        return response.statusCode == 200;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<bool> updateTeacherCategory(TeacherCategory teacherCategory) async {
      try {
        final response = await dio.put('$api/TeacherCategories/${teacherCategory.teacherCategoryId}', data: teacherCategory.toJson());
        return response.statusCode == 200;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<bool> addTeacherCategory(String teacherCategoryName) async {
      try {
        final response = await dio.post(
          '$api/TeacherCategories',
          data: {
            'teacherCategoryName': teacherCategoryName, // Используйте правильное название поля
          },
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          print('Ошибка при добавлении категории: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Ошибка при добавлении категории: $e');
        return false;
      }
    }

  ///////////Picture
    Future<List<Picture>> getPictures() async {
      try {
        final response = await dio.get('$api/Pictures');
        if (response.statusCode == 200) {
          List<Picture> pictures = (response.data as List)
              .map((json) => Picture.fromJson(json))
              .toList();
          return pictures;
        } else {
          throw Exception('Failed to load pictures from API: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching pictures: $e');
        throw Exception('Failed to load pictures from API: $e');
      }
    }


    Future<bool> addPicture(Picture picture) async {
      try {
        final response = await dio.post('$api/Pictures', data: picture.toJson());
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('Error adding picture: $e');
        return false;
      }
    }

    Future<bool> updatePicture(Picture picture) async {
      try {
        final response = await dio.put('$api/Pictures/${picture.pictureId}',
            data: picture.toJson());
        return response.statusCode == 200;
      } catch (e) {
        print('Error updating picture: $e');
        return false;
      }
    }

    Future<bool> deletePicture(int pictureId) async {
      try {
        final response = await dio.delete('$api/Pictures/$pictureId');
        return response.statusCode == 200;
      } catch (e) {
        print('Error deleting picture: $e');
        return false;
      }
    }
    ///////////////////////Requisites
    Future<List<Requisite>> getRequisites() async {
      try {
        final response = await dio.get('$api/Requisites');
        if (response.statusCode == 200) {
          List<Requisite> requisites = (response.data as List)
              .map((json) => Requisite.fromJson(json))
              .toList();
          return requisites;
        } else {
          throw Exception('Failed to load requisites from API: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching requisites: $e');
        throw Exception('Failed to load requisites from API: $e');
      }
    }

    Future<bool> addRequisite(Requisite requisite) async {
      try {
        final response = await dio.post('$api/Requisites', data: requisite.toJson());
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('Error adding requisite: $e');
        return false;
      }
    }

    Future<bool> updateRequisite(Requisite requisite) async {
      try {
        final response = await dio.put('$api/Requisites/${requisite.requisitesId}',
            data: requisite.toJson());
        return response.statusCode == 200;
      } catch (e) {
        print('Error updating requisite: $e');
        return false;
      }
    }

    Future<bool> deleteRequisite(int requisiteId) async {
      try {
        final response = await dio.delete('$api/Requisites/$requisiteId');
        return response.statusCode == 200;
      } catch (e) {
        print('Error deleting requisite: $e');
        return false;
      }
    }

  /////////User
    Future<bool> addUser(User user) async {
      try {
        final response = await dio.post(
          '$api/Users',
          data: user.toJson(),
        );
        return response.statusCode == 200 || response.statusCode == 201;
      } catch (e) {
        print('Error adding user: $e');
        return false;
      }
    }

    // Получаем список пользователей
    Future<List<User>> getUsers() async {
      try {
        final response = await dio.get('$api/Users');
        if (response.statusCode == 200) {
          List<User> users = (response.data as List)
              .map((json) => User.fromJson(json))
              .toList();
          return users;
        } else {
          throw Exception('Failed to load users from API: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching users: $e');
        throw Exception('Failed to load users from API: $e');
      }
    }

    // Обновляем пользователя
    Future<bool> updateUser(User user) async {
      try {
        final response = await dio.put('$api/Users/${user.usersId}', data: user.toJson());
        return response.statusCode == 200;
      } catch (e) {
        print('Error updating user: $e');
        return false;
      }
    }

    // Удаляем пользователя
    Future<bool> deleteUser(int userId) async {
      try {
        final response = await dio.delete('$api/Users/$userId');
        return response.statusCode == 200;
      } catch (e) {
        print('Error deleting user: $e');
        return false;
      }
    }
  }

