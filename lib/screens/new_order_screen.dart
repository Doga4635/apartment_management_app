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
  List<OrderModel> addedProducts = [];
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const GroceryListScreen()));
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
                const SizedBox(width: 50,),
                SizedBox(
                  width: 100,
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
              maxLength: 18,
              onChanged: (value) {
                setState(() {
                  _details = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Not',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createOrder();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
              child: const Text('Listeye Ekle',
                style: TextStyle(
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'Ürünler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: addedProducts.length,
              itemBuilder: (context, index) {
                OrderModel product = addedProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                      'Quantity: ${product.amount} - Details: ${product.details}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showConfirmationDialog(context, product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createList,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Listeyi Oluştur',
                style: TextStyle(
                    color: Colors.white),
              ),
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
      listId: '5b2de162',
      // sonra değiştir
      orderId: randomOrderId,
      productId: '1',
      name: _selectedProduct,
      amount: _quantity,
      details: _details,
    );

    ap.saveOrderDataToFirebase(
      context: context,
      orderModel: orderModel,
      onSuccess: () {
        setState(() {
          _selectedProduct = 'Ürün adı gir';
          _quantity = 1;
          _details = '';
          addedProducts.add(orderModel);
        });

      },
    );
  }


  void _showEditDialog(BuildContext context, OrderModel product) {
    final TextEditingController quantityController =
    TextEditingController(text: product.amount.toString());
    final TextEditingController detailsController =
    TextEditingController(text: product.details);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ürünü Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Miktar'),
              ),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: 'Ayrıntılar'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Get the updated values from the text fields
                int updatedQuantity = int.tryParse(quantityController.text) ?? product.amount;
                String updatedDetails = detailsController.text;

                // Update the order with the new values
                setState(() {
                  product.amount = updatedQuantity;
                  product.details = updatedDetails;
                });

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Kaydet'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, OrderModel product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('UYARI'),
          content: const Text('Bu ürünü silmek istediğinden emin misin?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                // Remove the item from the list and the database
                _deleteItem(product);
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }


    void _deleteItem(OrderModel product) {
      // Remove the item from the list
      setState(() {
        addedProducts.remove(product);
      });

      // Delete the item from the database
      // You can add the database deletion logic here if needed
    }


    void createList() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GroceryListScreen()),
      );
    }
  }

