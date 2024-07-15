import 'package:flutter/material.dart';
import 'package:restaurant/dbhelper.dart';
import 'dart:convert';

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<Map<String, dynamic>> _records = [];
  List<Map<String, dynamic>> availableFoods = [
    {'name': 'Pizza', 'cost': 10},
    {'name': 'Burger', 'cost': 8},
    {'name': 'Pasta', 'cost': 12},
    {'name': 'Salad', 'cost': 6},
    {'name': 'Sandwich', 'cost': 7},
    {'name': 'Sushi', 'cost': 15},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  Future<void> _fetchRecords() async {
    final dbHelper = DatabaseHelper();
    final records = await dbHelper.fetchRecords();
    setState(() {
      _records = records;
    });
  }

  Map<String, int> getFoodQuantities(List<String> foods) {
    Map<String, int> foodQuantities = {};
    for (var food in foods) {
      if (foodQuantities.containsKey(food)) {
        foodQuantities[food] = foodQuantities[food]! + 1;
      } else {
        foodQuantities[food] = 1;
      }
    }
    return foodQuantities;
  }

  double calculateTotalBill(Map<String, int> foodQuantities) {
    double total = 0;
    foodQuantities.forEach((food, quantity) {
      final foodItem = availableFoods.firstWhere((item) => item['name'] == food);
      total += foodItem['cost'] * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bills'),
      ),
      body: ListView.builder(
        itemCount: _records.length,
        itemBuilder: (context, index) {
          final record = _records[index];
          List<String> foods = List<String>.from(jsonDecode(record['foods']));
          Map<String, int> foodQuantities = getFoodQuantities(foods);
          double totalBill = calculateTotalBill(foodQuantities);

          if (foodQuantities.isEmpty) {
            return SizedBox.shrink(); // Don't show tables without food items
          }

          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text('Table ${record['table_no']}'),
              subtitle: Text('Waiter: ${record['person_name']}'),
              trailing: Text(
                'Bill: \$${totalBill.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: foodQuantities.length,
                  itemBuilder: (context, foodIndex) {
                    String food = foodQuantities.keys.elementAt(foodIndex);
                    int quantity = foodQuantities[food]!;
                    var itemTotal = availableFoods.firstWhere((item) => item['name'] == food)['cost'] * quantity;

                    return ListTile(
                      title: Text(food),
                      trailing: Text('$quantity x \$${itemTotal.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}