import 'package:flutter/material.dart';
import 'package:flutter_application_8/Models/GroupType.dart';
import 'package:flutter_application_8/services/api_service.dart';
import 'package:flutter_application_8/services/service_locator.dart';
import '../../Models/TeacherCategory.dart';

String searchQuery = '';

class TeacherCategoryScreen extends StatefulWidget {
  @override
  _TeacherCategoryScreenState createState() => _TeacherCategoryScreenState();
}

class _TeacherCategoryScreenState extends State<TeacherCategoryScreen> {
  late Future<List<TeacherCategory>> futureTeacherCategories;

  @override
  void initState() {
    super.initState();
    futureTeacherCategories = getTeacherCategories();
  }

  Future<List<TeacherCategory>> getTeacherCategories() async {
    return getIt<ApiService>().getTeacherCategories();
  }

  Future<void> _refreshTeacherCategories() async {
    setState(() {
      futureTeacherCategories = getTeacherCategories();
    });
  }

  void _showAddTeacherCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _teacherCategoryNameController = TextEditingController();

        return AlertDialog(
          title: Text("Новая квалификация"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _teacherCategoryNameController,
                decoration: InputDecoration(
                  labelText: "Квалификация",
                  hintText: "Введите квалификацию",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Назад"),
            ),
            TextButton(
              onPressed: () async {
                final teacherCategoryName = _teacherCategoryNameController.text;
                final success = await getIt<ApiService>().addTeacherCategory(teacherCategoryName);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Успешно добавлено!')));
                  _refreshTeacherCategories(); // обновляем список после успешного добавления
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка добавления категории.')));
                }
              },
              child: Text("Добавить"),
            ),
          ],
        );
      },
    );
  }





  void _showEditTeacherCategoryDialog(BuildContext context, TeacherCategory teacherCategory) {
    final _teacherCategoryNameController = TextEditingController(text: teacherCategory.teacherCategoryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Редактировать"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _teacherCategoryNameController,
                decoration: InputDecoration(
                  labelText: "Квалификация",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Отмена"),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final TeacherCategory updatedTeacherCategory = TeacherCategory(
                  teacherCategoryId: teacherCategory.teacherCategoryId,
                  teacherCategoryName: _teacherCategoryNameController.text,
                );

                final success = await getIt<ApiService>().updateTeacherCategory(updatedTeacherCategory);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Успешно обновлено!')));
                } else {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка обновления типа.')));
                }
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check),
              label: Text("Сохранить"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
            ),
          ],
        );

      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int teacherCategoryId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Подтверждение удаления"),
          content: Text("Уверены, что удаляете?"),
          actions: <Widget>[
            TextButton(
              child: Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Удалить"),
              onPressed: () async {
                await getIt<ApiService>().deleteTeacherCategory(teacherCategoryId);
                _refreshTeacherCategories();
                Navigator.of(context).pop();
              },
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
        title: Text('Квалификации'),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: FutureBuilder<List<TeacherCategory>>(
        future: futureTeacherCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _refreshTeacherCategories,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  TeacherCategory teacherCategory = snapshot.data![index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            teacherCategory.teacherCategoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showEditTeacherCategoryDialog(context, teacherCategory);
                              },
                              child: Text('Редактировать'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, teacherCategory.teacherCategoryId);
                              },
                              child: Text('Удалить'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('Нет данных'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTeacherCategoryDialog(context);
        },
        child: Icon(Icons.add), // Заменяем иконку на галочку
        backgroundColor: Colors.green,
      ),
    );
  }
}
