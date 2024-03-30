import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_8/Models/Picture.dart';
import 'package:flutter_application_8/services/api_service.dart';

class PictureScreen extends StatefulWidget {
  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  late Future<List<Picture>> futurePictures;

  late final Dio dio;
  late final ApiService apiService;

  TextEditingController photoDataController = TextEditingController();
  TextEditingController uploadDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dio = Dio();
    apiService = ApiService(dio);
    futurePictures = apiService.getPictures();

    // Заполняем дату загрузки текущей датой и временем
    uploadDateController.text = DateTime.now().toString();
  }

  void _showAddPictureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новую картину'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: photoDataController,
                  decoration: InputDecoration(labelText: 'Фото'),
                ),
                TextField(
                  controller: uploadDateController,
                  decoration: InputDecoration(labelText: 'Дата загрузки'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                photoDataController.clear();
                uploadDateController.clear();
                Navigator.of(context).pop();

              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                String photoData = photoDataController.text;

                Picture newPicture = Picture(
                  pictureId: 0,
                  photoData: photoData,
                  uploadDate: DateTime.parse(uploadDateController.text),
                );

                bool success = await apiService.addPicture(newPicture);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Картина успешно добавлена')),
                  );
                  Navigator.of(context).pop();
                  _refreshPictures();

                  // Очистка полей формы после успешного добавления
                  photoDataController.clear();
                  uploadDateController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Успешно добавлено')),
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


  void _showEditPictureDialog(BuildContext context, Picture picture) {
    // Диалог для редактирования
    photoDataController.text = picture.photoData;
    uploadDateController.text = picture.uploadDate.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактировать картину'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: photoDataController,
                  decoration: InputDecoration(labelText: 'Фото'),
                ),
                TextField(
                  controller: uploadDateController,
                  decoration: InputDecoration(labelText: 'Дата загрузки'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                photoDataController.clear();
                uploadDateController.clear();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                String photoData = photoDataController.text;

                Picture editedPicture = Picture(
                  pictureId: picture.pictureId,
                  photoData: photoData,
                  uploadDate: DateTime.parse(uploadDateController.text),
                );

                photoDataController.clear();
                uploadDateController.clear();
                _refreshPictures();
                Navigator.of(context).pop();
                bool success = await apiService.updatePicture(editedPicture);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Картина успешно отредактирована')),
                  );
                   // Закрываем диалоговое окно после успешного сохранения

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Успешно обновлено'),
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


  void _refreshPictures() {
    setState(() {
      futurePictures = apiService.getPictures();
    });
  }

  void _refreshPage() {
    _refreshPictures();

    // Очистка полей формы при обновлении страницы

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фото'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshPage,
          ),
        ],
      ),
      body: FutureBuilder<List<Picture>>(
        future: futurePictures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Picture picture = snapshot.data![index];
                return Dismissible(
                  key: Key(picture.pictureId.toString()),
                  direction: DismissDirection.horizontal,
                  // Разрешаем свайп по горизонтали
                  onDismissed: (direction) async {
                    bool success =
                    await apiService.deletePicture(picture.pictureId);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Картина успешно удалена')),
                      );
                      _refreshPictures();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка при удалении картины')),
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
                    title: Text('ID: ${picture.pictureId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Фото: ${picture.photoData}'),
                        SizedBox(height: 10),
                        Text('Дата загрузки: ${picture.uploadDate.toString()}'),
                      ],
                    ),
                    leading: Container(
                      width: 100,
                      height: 100,
                      child: Image.network(
                        picture.photoData,
                        fit: BoxFit.cover,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditPictureDialog(context, picture);
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
          uploadDateController.text = DateTime.now().toString();
          _showAddPictureDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
