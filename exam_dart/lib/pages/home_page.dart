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
    if (itemController.text.isEmpty || nameController.text.isEmpty) return;

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order added successfully!')),
    );
  }

  void searchOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void deleteOrder(Order order) {
    setState(() {
      orders.remove(order);
      filteredOrders = List.from(orders);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${order.itemName} deleted')),
    );
  }

  Widget buildOrderCard(Order order) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          order.itemName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${order.item} • ${order.currency} ${order.price} • Qty: ${order.quantity}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => deleteOrder(order),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📦 Order Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: '🔍 Search by ItemName',
                border: OutlineInputBorder(),
              ),
              onChanged: searchOrders,
            ),
            const SizedBox(height: 12),
            ...filteredOrders.map(buildOrderCard),
            const Divider(height: 30),
            const Text('➕ Add New Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            buildInputField('Item', itemController),
            buildInputField('ItemName', nameController),
            buildInputField('Price', priceController,
                keyboardType: TextInputType.number),
            buildInputField('Currency', currencyController),
            buildInputField('Quantity', quantityController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: addOrder,
              icon: const Icon(Icons.add),
              label: const Text('Insert Order'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
