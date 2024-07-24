import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_assessment_june/models/cart.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../models/product/product.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    final List<dynamic> productData = json.decode(response.body);
    setState(() {
      _products = productData.map((json) => Product.fromMap(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 244),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 246, 246, 244),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.black,
          ),
          title: const Text('Products',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              )),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.orange[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Consumer<Cart>(
                      builder: (ctx, cart, _) => Text(
                        cart.itemCount.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // search bar
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10.0),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: RefreshIndicator(
                onRefresh: () async {
                  await _fetchProducts();
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _products.length,
                  itemBuilder: (ctx, i) => ProductItem(
                    product: _products[i],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
