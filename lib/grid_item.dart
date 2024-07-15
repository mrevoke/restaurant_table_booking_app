// lib/widgets/grid_item.dart

import 'package:flutter/material.dart';
import 'dart:convert';

class GridItem extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;

  GridItem({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double squareSideLength = MediaQuery.of(context).size.width * 0.25;

    List<String> foods = List<String>.from(jsonDecode(record['foods']));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: squareSideLength,
          height: squareSideLength,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(15.0),
            gradient: getGradient(record['person_name']),
          ),
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'T ${record['table_no']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              if (record['person_name'].isNotEmpty)
                Text(
                  '${record['person_name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              Spacer(),
              Text(
                record['person_name'].isNotEmpty ? "Occupied" : "Free",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient getGradient(String personName) {
    switch (personName) {
      case 'Waiter 1':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.red, Colors.red],
          stops: [0.8, 0.8, 1.0],
        );
      case 'Waiter 2':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey, Colors.grey],
          stops: [0.8, 0.8, 1.0],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.green, Colors.green],
          stops: [0.8, 0.8, 1.0],
        );
    }
  }
}
