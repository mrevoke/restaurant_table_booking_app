import 'package:flutter/material.dart';
import 'package:restaurant/dbhelper.dart';
import 'dart:convert';

class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> record;

  DetailScreen({required this.record});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, int> foodQuantities = {};
  List<Map<String, dynamic>> availableFoods = [
    {'name': 'Pizza', 'cost': 10, 'image': 'https://images7.alphacoders.com/596/596343.jpg'},
    {'name': 'Burger', 'cost': 8, 'image': 'https://brookrest.com/wp-content/uploads/2020/05/AdobeStock_282247995-scaled.jpeg'},
    {'name': 'Pasta', 'cost': 12, 'image': 'https://ouritaliantable.com/wp-content/uploads/2010/06/crabmeat-pasta.jpg'},
    {'name': 'Salad', 'cost': 6, 'image': 'https://www.tasteofhome.com/wp-content/uploads/2018/01/Simple-Italian-Salad_EXPS_FT20_25957_F_0624_1.jpg'},
    {'name': 'Sandwich', 'cost': 7, 'image': 'https://www.jocooks.com/wp-content/uploads/2020/10/club-sandwich-1-6-1536x1152.jpg'},
    {'name': 'Sushi', 'cost': 15, 'image': 'https://www.thespruceeats.com/thmb/IzejeJObvz4lvYpW06uwhX6iR00=/3680x2456/filters:fill(auto,1)/GettyImages-Ridofranz-1053855542-60b89644efd2470fbfb6475b175064df.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    List<String> foods = List<String>.from(jsonDecode(widget.record['foods']));
    for (var food in foods) {
      if (foodQuantities.containsKey(food)) {
        foodQuantities[food] = foodQuantities[food]! + 1;
      } else {
        foodQuantities[food] = 1;
      }
    }
  }

  void addFood(String food) {
    setState(() {
      if (foodQuantities.containsKey(food)) {
        foodQuantities[food] = foodQuantities[food]! + 1;
      } else {
        foodQuantities[food] = 1;
      }
    });
  }

  void removeFood(String food) {
    setState(() {
      if (foodQuantities.containsKey(food)) {
        if (foodQuantities[food]! > 1) {
          foodQuantities[food] = foodQuantities[food]! - 1;
        } else {
          foodQuantities.remove(food);
        }
      }
    });
  }

  double calculateTotalBill() {
    double total = 0;
    foodQuantities.forEach((food, quantity) {
      final foodItem = availableFoods.firstWhere((item) => item['name'] == food);
      total += foodItem['cost'] * quantity;
    });
    return total;
  }

  Future<void> saveOrder() async {
    final dbHelper = DatabaseHelper();
    String foodsJson = jsonEncode(foodQuantities.keys.toList());
    await dbHelper.updateRecord(widget.record['table_no'], 'Waiter 1', foodQuantities.keys.toList(), "");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalBill = calculateTotalBill();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        title: Row(
          children: [
            Spacer(),
            Text('T ${widget.record['table_no']}'),
            Text('  \$${totalBill.toStringAsFixed(2)}', style: TextStyle(color: Colors.blueAccent)),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: saveOrder,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: foodQuantities.length,
                itemBuilder: (context, index) {
                  String food = foodQuantities.keys.elementAt(index);
                  int quantity = foodQuantities[food]!;
                  var totalPrice = availableFoods.firstWhere((item) => item['name'] == food)['cost'] * quantity;

                  return Dismissible(
                    key: Key(food),
                    onDismissed: (direction) {
                      removeFood(food);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text("$quantity *", style: TextStyle(color: Colors.blueAccent)),
                              Text(' $food'),
                            ],
                          ),
                          Text('\$${totalPrice.toStringAsFixed(2)}', style: TextStyle(color: Colors.blueAccent)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 1),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableFoods.length,
                      itemBuilder: (context, index) {
                        final food = availableFoods[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                food['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(food['name']),
                            trailing: Text('\$${food['cost']}'),
                            onTap: () {
                              addFood(food['name']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}