// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:restaurant/detail_screen.dart';
import 'package:restaurant/drawer_menu.dart';
import 'package:restaurant/grid_item.dart';
import 'package:restaurant/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    _homeBloc.init();
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double squareSideLength = MediaQuery.of(context).size.width * 0.25;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('Restaurant')),
      drawer: DrawerMenu(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _homeBloc.recordsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final records = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
            ),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return GridItem(record: record, onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(record: record),
                  ),
                );
                _homeBloc.fetchRecords();
              });
            },
          );
        },
      ),
    );
  }
}
