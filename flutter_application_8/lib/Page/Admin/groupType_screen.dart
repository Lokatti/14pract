import 'package:flutter/material.dart';
import 'package:flutter_application_8/Models/GroupType.dart';
import 'package:flutter_application_8/services/api_service.dart';
import 'package:flutter_application_8/services/service_locator.dart';

import 'GroupTypeSearch.dart';


String searchQuery = '';

class GroupTypeScreen extends StatefulWidget {
  @override
  _GroupTypeScreenState createState() => _GroupTypeScreenState();
}

class _GroupTypeScreenState extends State<GroupTypeScreen> {
  late Future<List<GroupType>> futureGroupTypes;

  @override
  void initState() {
    super.initState();
    futureGroupTypes = getGroupTypes();
  }

  Future<List<GroupType>> getGroupTypes() async {
    return getIt<ApiService>().getGroupTypes();
  }

  Future<void> _refreshGroupTypes() async {
    setState(() {
      futureGroupTypes = getGroupTypes();
    });
  }

  void _showAddGroupTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _groupTypeNameController = TextEditingController();
        final _descriptionTypeController = TextEditingController();

        return AlertDialog(
          title: Text("Новый тип групп"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _groupTypeNameController,
                decoration: InputDecoration(
                  labelText: "Тип",
                  hintText: "Введите тип",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionTypeController,
                decoration: InputDecoration(
                  labelText: "Описание",
                  hintText: "Введите описание",
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
                final groupTypeName = _groupTypeNameController.text;
                final descriptionType = _descriptionTypeController.text;
                final success = await getIt<ApiService>().addGroupType(groupTypeName, descriptionType);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Тип группы успешно добавлен!')));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка добавления типа.')));
                }
              },
              child: Text("Добавить"),
            ),
          ],
        );

      },
    );
  }

  void _showEditGroupTypeDialog(BuildContext context, GroupType groupType) {
    final _groupTypeNameController = TextEditingController(text: groupType.groupTypeName);
    final _descriptionTypeController = TextEditingController(text: groupType.descriptionType.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Редактировать тип группы"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _groupTypeNameController,
                decoration: InputDecoration(
                  labelText: "Тип",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionTypeController,
                decoration: InputDecoration(
                  labelText: "Описание",
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
                final GroupType updatedGroupType = GroupType(
                  groupTypeId: groupType.groupTypeId,
                  groupTypeName: _groupTypeNameController.text,
                  descriptionType: _descriptionTypeController.text,
                );

                final success = await getIt<ApiService>().updateGroupType(updatedGroupType);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Тип успешно обновлен!')));
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

  void _showDeleteConfirmationDialog(BuildContext context, int groupTypeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Подтверждение удаления"),
          content: Text("Уверены, что удаляете тип?"),
          actions: <Widget>[
            TextButton(
              child: Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Удалить"),
              onPressed: () async {
                await getIt<ApiService>().deleteGroupType(groupTypeId);
                _refreshGroupTypes();
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
        title: Text('Типы группы'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Row(
              children: [
                Icon(Icons.search), // Иконка поиска
                SizedBox(width: 5), // Небольшой отступ между иконкой и текстом
                Text('Поиск'), // Текст надписи
              ],
            ),
            onPressed: () {
              showSearch(context: context, delegate: GroupTypeSearch());
            },
            tooltip: 'Поиск', // Добавляем всплывающую подсказку
          ),

        ],
      ),
      body: FutureBuilder<List<GroupType>>(
        future: futureGroupTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _refreshGroupTypes,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  GroupType groupType = snapshot.data![index];
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
                            groupType.groupTypeName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            groupType.descriptionType,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _showEditGroupTypeDialog(context, groupType);
                              },
                              child: Text('Редактировать'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, groupType.groupTypeId);
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
            return Center(child: Text('Нет типов групп('));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGroupTypeDialog(context);
        },
        child: Icon(Icons.add), // Заменяем иконку на галочку
        backgroundColor: Colors.green,
      ),
    );
  }
}
