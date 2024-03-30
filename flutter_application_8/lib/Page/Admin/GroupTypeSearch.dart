import 'package:flutter/material.dart';
import 'package:flutter_application_8/Models/GroupType.dart';
import 'package:flutter_application_8/services/api_service.dart';
import 'package:flutter_application_8/services/service_locator.dart';

class GroupTypeSearch extends SearchDelegate<dynamic> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Эмуляция асинхронной загрузки данных
    final futureGroupTypes = getIt<ApiService>().getGroupTypes();

    return FutureBuilder<List<GroupType>>(
      future: futureGroupTypes,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final results = snapshot.data!.where((GroupType groupType) => groupType.groupTypeName.toLowerCase().contains(query.toLowerCase())).toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final GroupType groupType = results[index];
            return ListTile(
              title: Text(groupType.groupTypeName),
              subtitle: Text('${groupType.descriptionType}'),
              onTap: () {
                close(context, groupType); // Возвращает выбранное Шава и закрывает поиск
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Эмуляция асинхронной загрузки данных
    final futureGroupTypes = getIt<ApiService>().getGroupTypes();

    return FutureBuilder<List<GroupType>>(
      future: futureGroupTypes,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final suggestions = snapshot.data!.where((GroupType groupType) => groupType.groupTypeName.toLowerCase().contains(query.toLowerCase())).toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final GroupType groupType = suggestions[index];
            return ListTile(
              title: Text(groupType.groupTypeName),
              subtitle: Text('${groupType.descriptionType}'),
              onTap: () {
                query = groupType.groupTypeName; // Обновляет поисковый запрос до полного названия пива
                showResults(context); // Показывает результаты на основе обновленного запроса
              },
            );
          },
        );
      },
    );
  }
}
