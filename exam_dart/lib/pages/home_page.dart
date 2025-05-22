import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Order> orders = [];
  List<Order> filteredOrders = [];

  final jsonString = '''
  [{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency": "USD","Quantity":1},
   {"Item": "A1001","ItemName": "Iphone 16","Price": 1500,"Currency": "USD","Quantity":1}]
  ''';

  final searchController = TextEditingController();
  final itemController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final currencyController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() {
    final List<dynamic> jsonData = jsonDecode(jsonString);
    orders = jsonData.map((data) => Order.fromJson(data)).toList();
    filteredOrders = List.from(orders);
  }

  void addOrder() {
    final newOrder = Order(
      item: itemController.text,
      itemName: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      currency: currencyController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
    );

    setState(() {
      orders.add(newOrder);
      filteredOrders = List.from(orders);
    });

    itemController.clear();
    nameController.clear();
    priceController.clear();
    currencyController.clear();
    quantityController.clear();
  }

  void searchOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget buildOrderCard(Order order) {
    return Card(
      child: ListTile(
        title: Text(order.itemName),
        subtitle: Text(
            '${order.item} - ${order.currency} ${order.price} x ${order.quantity}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order List')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search by ItemName'),
              onChanged: searchOrders,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: filteredOrders.map(buildOrderCard).toList(),
              ),
            ),
            const Divider(),
            const Text('Add New Order'),
            TextField(controller: itemController, decoration: const InputDecoration(labelText: 'Item')),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'ItemName')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price')),
            TextField(controller: currencyController, decoration: const InputDecoration(labelText: 'Currency')),
            TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantity')),
            ElevatedButton(onPressed: addOrder, child: const Text('Insert Order')),
          ],
        ),
      ),
    );
  }
}
