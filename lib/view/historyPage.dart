import 'package:flutter/material.dart';
import 'package:qrreader/constants.dart';
import 'package:qrreader/model/historyModel.dart';
import 'package:sqflite/sqflite.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({super.key, required this.database});
  Database database;

  Future<List<HistoryModel>> Histories() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('history');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    var list = List.generate(maps.length, (i) {
      return HistoryModel(
        text: maps[i]['text'],
        dateTime: maps[i]['dateTime'],
        hour: maps[i]['hour'],
      );
    });

    return list.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "History",
          style: kFontPoppins,
        ),
      ),
      body: Scaffold(
        body: FutureBuilder(
          future: Histories(),
          builder: (context, snapshot) => ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].text, style: kFontPoppins),
                subtitle:
                    Text(snapshot.data![index].dateTime, style: kFontPoppins),
                trailing:
                    Text(snapshot.data![index].hour, style: kFontPoppins20),
              );
            },
          ),
        ),
      ),
    );
  }
}
