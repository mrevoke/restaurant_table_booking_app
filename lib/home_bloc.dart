// lib/blocs/home_bloc.dart

import 'dart:async';
import 'package:restaurant/dbhelper.dart';

class HomeBloc {
  final _recordsController = StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get recordsStream => _recordsController.stream;

  void init() {
    insertInitialEntries();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.fetchRecords();
    _recordsController.sink.add(records);
  }

  Future<void> insertInitialEntries() async {
    final dbHelper = DatabaseHelper();
    for (int i = 1; i <= 15; i++) {
      await dbHelper.insertRecord(i, '', [], '');
    }
  }

  void dispose() {
    _recordsController.close();
  }
}
