import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../screens/grocery_list_screen.dart';
import '../services/auth_supplier.dart';
import '../utils/utils.dart';
import 'alim_screen.dart';


class NewOrderScreen extends StatefulWidget {

  final String listId;
  final List<String> days;
  final String flatId;
  final String apartmentId;
  final String floorNo;
  final String flatNo;
  final String role;

  const NewOrderScreen({Key? key, required this.listId, required this.days, required this.flatId, required this.apartmentId, required this.floorNo, required this.flatNo, required this.role}) : super(key: key);


  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}
class NewOrderScreenState extends State<NewOrderScreen> {
  String _selectedProduct = 'Ürün adı giriniz';
  List<String> productList = [];
  List<OrderModel> addedProducts = [];
  String _selectedPlace = 'Yeri seçiniz';
  final productNameController = TextEditingController();
  final placeNameController = TextEditingController();


  List<String> placeList = ['Market', 'Fırın', 'Manav', 'Diğer'];
  int _quantity = 1;
  String _details = '';
  bool _isLoading = true;




  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    placeNameController.dispose();
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
    productList.add('Diğer');
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
            _showExitConfirmationDialog();
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
                setState(() {
                  _isLoading = true;
                  _selectedProduct = value;
                  _isLoading = false;
                });
              },
            ),
            const SizedBox(height: 6),
            _selectedProduct == 'Diğer' ?
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: TextField(
                keyboardType: TextInputType.name,
                controller: productNameController,
                decoration: const InputDecoration(
                  hintText: 'Yeni ürünün adını yazın',
                ),
              ),
            ) :
            const SizedBox(height: 10),
            const SizedBox(height: 10),
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
                const SizedBox(
                  width: 50,
                ),
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
            CustomDropdown<String>.search(
              hintText: _selectedPlace,
              items: placeList,
              excludeSelected: false,
              onChanged: (value) {
                setState(() {
                  _isLoading = true;
                  _selectedPlace = value;
                  _isLoading = false;
                });
              },
            ),
            const SizedBox(height: 6),
            _selectedPlace == 'Diğer' ?
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: TextField(
                keyboardType: TextInputType.name,
                controller: placeNameController,
                decoration: const InputDecoration(
                  hintText: 'Yeni yerin adını yazın',
                ),
              ),
            ) :
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: createOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              child: const Text(
                'Listeye Ekle',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '  Liste',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: addedProducts.length,
              itemBuilder: (context, index) {
                OrderModel product = addedProducts[index];
                return ListTile(
                  title: Text('${product.name} - Miktar: ${product.amount}'),
                  subtitle: Text(
                      'Not: ${product.details} - Yer: ${product.place}'),
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
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                createList(saveList: true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AlimScreen()),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryListScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text(
                'Listeyi Oluştur',
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }




  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dikkat!'),
          content: const Text('Listeyi kaydetmek istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // User wants to save the list
                createList(saveList: true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GroceryListScreen()),
                );
              },
              child: const Text('Evet'),
            ),
            TextButton(
              onPressed: () {
                // User doesn't want to save the list
                Navigator.of(context).pop();
                createList(saveList: false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GroceryListScreen()),
                );
              },
              child: const Text('Hayır'),
            ),
          ],
        );
      },
    );
  }


  void createOrder() async {
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    String randomOrderId = generateRandomId(10);

    // Get the current user's flatId
    String currentUserUid = ap.userModel.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('flats')
        .where('uid', isEqualTo: currentUserUid)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first);
    String flatId = userDoc['flatId'];



    if(_selectedProduct == 'Diğer' || _selectedPlace == 'Diğer') {
      if(_selectedProduct != 'Diğer') {
        OrderModel orderModel = OrderModel(
          listId: widget.listId,
          orderId: randomOrderId,
          productId: '1',
          name: _selectedProduct,
          amount: _quantity,
          price: 0,
          details: _details,
          place: placeNameController.text.trim(),
          days: widget.days,
          flatId: widget.flatId,
          apartmentId: widget.apartmentId,
          flatNo: widget.flatNo,
          floorNo: widget.floorNo,
          role: widget.role,
        );


        ap.saveOrderDataToFirebase(
          context: context,
          orderModel: orderModel,
          onSuccess: () {
            setState(() {
              addedProducts.add(orderModel);
            });
          },
        );
      }

      else if(_selectedPlace != 'Diğer') {
        OrderModel orderModel = OrderModel(
          listId: widget.listId,
          orderId: randomOrderId,
          productId: '1',
          name: productNameController.text.trim(),
          amount: _quantity,
          price: 0,
          details: _details,
          place: _selectedPlace,
          days: widget.days,
          flatId: widget.flatId,
          apartmentId: widget.apartmentId,
          flatNo: widget.flatNo,
          floorNo: widget.floorNo,
          role: widget.role,
        );


        ap.saveOrderDataToFirebase(
          context: context,
          orderModel: orderModel,
          onSuccess: () {
            setState(() {
              addedProducts.add(orderModel);
            });
          },
        );
      }
      else {
        OrderModel orderModel = OrderModel(
          listId: widget.listId,
          orderId: randomOrderId,
          productId: '1',
          name: productNameController.text.trim(),
          amount: _quantity,
          price: 0,
          details: _details,
          place: placeNameController.text.trim(),
          days: widget.days,
          flatId: widget.flatId,
          apartmentId: widget.apartmentId,
          flatNo: widget.flatNo,
          floorNo: widget.floorNo,
          role: widget.role,
        );


        ap.saveOrderDataToFirebase(
          context: context,
          orderModel: orderModel,
          onSuccess: () {
            setState(() {
              addedProducts.add(orderModel);
            });
          },
        );
      }
    }

    else {
      OrderModel orderModel = OrderModel(
        listId: widget.listId,
        orderId: randomOrderId,
        productId: '1',
        name: _selectedProduct,
        amount: _quantity,
        price: 0,
        details: _details,
        place: _selectedPlace,
        days: widget.days,
        flatId: widget.flatId,
        apartmentId: widget.apartmentId,
        flatNo: widget.flatNo,
        floorNo: widget.floorNo,
        role: widget.role,
      );


    ap.saveOrderDataToFirebase(
      context: context,
      orderModel: orderModel,
      onSuccess: () {
        setState(() {
          addedProducts.add(orderModel);
        });
      },
    );
  }

    setState(() {
      _selectedProduct = 'Ürün adı giriniz';
      _selectedPlace = 'Yeri seçiniz';
      _details = '';
      productNameController.clear();
      placeNameController.clear();
    });

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
                int updatedQuantity =
                    int.tryParse(quantityController.text) ?? product.amount;
                String updatedDetails = detailsController.text;


                // Update the order with the new values
                setState(() {
                  product.amount = updatedQuantity;
                  product.details = updatedDetails;
                });


                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(product.orderId)
                    .update({
                  'amount': updatedQuantity,
                  'details': updatedDetails,
                }).then((value) {
                  Navigator.pop(context);
                  showSnackBar('Ürün güncellendi');
                }).catchError((error) {
                  showSnackBar('Ürün güncellendi');
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


  Future<void> _deleteItem(OrderModel product) async {
    // Remove the item from the list
    setState(() {
      addedProducts.remove(product);
    });


    try {
      // Delete the item from the database
      await FirebaseFirestore.instance
          .collection('orders') // Change 'orders' to your collection name
          .doc(product.orderId) // Assuming orderId is the document ID
          .delete();
      showSnackBar('Ürün listeden silindi');
    } catch (error) {
      showSnackBar('Ürünü listeden kaldırırken bir sorun oluştu');
      // Handle any error that occurs during deletion
    }
  }


  Future<void> createList({bool saveList = false}) async {
    if (saveList) {
      try {
        // Save each item in addedProducts to Firebase
        for (OrderModel product in addedProducts) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(product.orderId)
              .set(product.toMap()); // Convert OrderModel to a Map using toMap method
          showSnackBar('Ürün başarılı bir şekilde eklendi.');
        }
      } catch (error) {


        showSnackBar('Ürün eklenirken hata oluştu: $error');
        // Handle any error that occurs during saving
      }
    } else {
// If not saving the list, delete all items from the database
      for (OrderModel product in addedProducts) {
        try {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(product.orderId)
              .delete();


          showSnackBar('Ürün başarılı bir şekilde silindi');
        } catch (error) {


          showSnackBar('Ürün silinirken hata oluştu: $error');
          // Handle any error that occurs during deletion
        }
      }

      await FirebaseFirestore.instance
          .collection('lists')
          .doc(widget.listId)
          .delete();

    }
  }
}