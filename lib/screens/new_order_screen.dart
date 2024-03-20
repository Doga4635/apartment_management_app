import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:apartment_management_app/models/order_model.dart';
import 'package:apartment_management_app/models/product_model.dart';
import 'package:apartment_management_app/screens/grocery_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../services/auth_supplier.dart';
import '../utils/utils.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends State<NewOrderScreen> {
  String _selectedProduct = 'Ürün adı gir';
  List<String> productList = [];
  int _quantity = 1;
  String _details = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  Future<void> _getProducts() async {
    QuerySnapshot productSnapshot =
    await FirebaseFirestore.instance.collection('products').get();

    List<ProductModel> products = productSnapshot.docs.map((doc) {
      return ProductModel(
        productId: doc['productId'] ?? '',
        name: doc['name'] ?? '',
      );
    }).toList();

    productList = products.map((product) => product.name).toList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Liste'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const GroceryListScreen()));
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : CustomDropdown<String>.search(
              hintText: _selectedProduct,
              items: productList,
              excludeSelected: false,
              onChanged: (value) {
                _selectedProduct = value;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_quantity > 1) _quantity--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        _quantity = int.tryParse(value) ?? 1;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Miktar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              maxLength: 24,
              onChanged: (value) {
                setState(() {
                  _details = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Ayrıntılar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:  () => createOrder(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Listeye Ekle'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Ürünler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
             ListTile(
              title: Text('Product Name'),
              subtitle: Text('Quantity: 1 - Details: Some details'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context);
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:  () => createOrder(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Listeyi Oluştur'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void createOrder() async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String randomOrderId = generateRandomId(10);

    OrderModel orderModel = OrderModel(
      listId: '5b2de162',  // sonra değiştir
      orderId: randomOrderId,
      productId: '1',
      name: _selectedProduct,
      amount: _quantity,
      details: _details,
    );

      ap.saveOrderDataToFirebase(
        context: context,
        orderModel: orderModel,
        onSuccess: () {},
      );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ürünü Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Ürün İsmi'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Miktar'),
              ),
              TextField(
                controller: detailsController,
                decoration: InputDecoration(labelText: 'Ayrıntılar'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Implement your update logic here
                // You can access the entered values using
                // nameController.text, quantityController.text, detailsController.text
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


}
