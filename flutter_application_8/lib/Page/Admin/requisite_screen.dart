import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_8/Models/Requisite.dart';
import 'package:flutter_application_8/services/api_service.dart';

class RequisiteScreen extends StatefulWidget {
  @override
  _RequisiteScreenState createState() => _RequisiteScreenState();
}

class _RequisiteScreenState extends State<RequisiteScreen> {
  late Future<List<Requisite>> futureRequisites;

  late final Dio dio;
  late final ApiService apiService;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);
    futureRequisites = apiService.getRequisites();

    // Заполняем поля пустыми значениями
    cardNumberController.text = '';
    balanceController.text = '';
  }

  void _showAddRequisiteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый реквизит'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(labelText: 'Номер карты'),
                ),
                TextField(
                  controller: balanceController,
                  decoration: InputDecoration(labelText: 'Баланс'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                cardNumberController.clear();
                balanceController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cardNumber = cardNumberController.text;
                double balance = double.parse(balanceController.text);

                Requisite newRequisite = Requisite(
                  requisitesId: 0,
                  cardNumber: cardNumber,
                  balance: balance,
                );

                bool success = await apiService.addRequisite(newRequisite);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Реквизит успешно добавлен')),
                  );
                  Navigator.of(context).pop();
                  cardNumberController.clear();
                  balanceController.clear();
                  _refreshRequisites();

                  // Очистка полей формы после успешного добавления
                  cardNumberController.clear();
                  balanceController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка при добавлении реквизита')),
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

  void _showEditRequisiteDialog(BuildContext context, Requisite requisite) {
    // Диалог для редактирования
    cardNumberController.text = requisite.cardNumber;
    balanceController.text = requisite.balance.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактировать'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(labelText: 'Номер'),
                ),
                TextField(
                  controller: balanceController,
                  decoration: InputDecoration(labelText: 'Баланс'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                cardNumberController.clear();
                balanceController.clear();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                String cardNumber = cardNumberController.text;
                double balance = double.parse(balanceController.text);

                Requisite editedRequisite = Requisite(
                  requisitesId: requisite.requisitesId,
                  cardNumber: cardNumber,
                  balance: balance,
                );

                cardNumberController.clear();
                balanceController.clear();
                _refreshRequisites();
                Navigator.of(context).pop();
                bool success = await apiService.updateRequisite(editedRequisite);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Реквизит успешно отредактирован')),
                  );
                  // Закрываем диалоговое окно после успешного сохранения
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка при редактировании реквизита'),
                    ),
                  );
                }
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }


  void _refreshRequisites() {
    setState(() {
      futureRequisites = apiService.getRequisites();
    });
  }

  void _refreshPage() {
    _refreshRequisites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Реквизиты'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: FutureBuilder<List<Requisite>>(
        future: futureRequisites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Requisite requisite = snapshot.data![index];
                return Dismissible(
                  key: Key(requisite.requisitesId.toString()),
                  direction: DismissDirection.horizontal,
                  // Разрешаем свайп по горизонтали
                  onDismissed: (direction) async {
                    bool success = await apiService
                        .deleteRequisite(requisite.requisitesId);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Реквизит успешно удален')),
                      );
                      _refreshRequisites();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Ошибка при удалении реквизита')),
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ListTile(
                    title: Text('ID: ${requisite.requisitesId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Номер карты: ${requisite.cardNumber}'),
                        SizedBox(height: 10),
                        Text('Баланс: ${requisite.balance.toString()}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditRequisiteDialog(context, requisite);
                      },
                    ),
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
          _showAddRequisiteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
