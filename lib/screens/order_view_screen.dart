import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_supplier.dart';
import 'ana_menü_yardım_screen.dart';

class OrderViewScreen extends StatefulWidget {
  final String listId;

  const OrderViewScreen({Key? key, required this.listId}) : super(key: key);

  @override
  OrderViewScreenState createState() => OrderViewScreenState();
}

class OrderViewScreenState extends State<OrderViewScreen> {
  List<String> orderName = [];
  List<String> orderPlace = [];
  List<String> orderDetails = [];
  List<String> orderIdList = [];
  List<int> orderAmount = [];
  String listId = "";

  @override
  void initState() {
    super.initState();
    listId = widget.listId;
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    getOrderDetails(
        currentUserUid, listId, orderName, orderPlace, orderAmount, orderDetails, orderIdList);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final ap = Provider.of<AuthSupplier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sipariş Özeti'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 350.0,
                  height: 330.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: orderName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderItem(
                        listId: listId,
                        orderName: orderName[index],
                        orderAmount: orderAmount[index],
                        orderPlace: orderPlace[index],
                        orderDetails: orderDetails[index],
                        orderIdList: orderIdList,
                        onUpdate: (newName, newAmount, newPlace, newDetails) {
                          updateFirestore(
                            index,
                            newName,
                            newAmount,
                            newPlace,
                            newDetails,
                            orderIdList,
                          );
                        },
                        onDelete: () {
                          deleteItemFromFirestore(orderIdList[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YardimScreen()),
                );
              },
              tooltip: 'Yardım',
              backgroundColor: Colors.teal,
              child: const Icon(
                Icons.question_mark,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getOrderDetails(String currentUserUid, String listId, List<String> updatedOrderName,
      List<String> updatedOrderPlace, List<int> updatedOrderAmount, List<String> updatedOrderDetails, List<String> updatedOrderId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('listId', isEqualTo: listId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          String? orderName = data['name'] as String?;
          String? orderPlace = data['place'] as String?;
          int? orderAmount = data['amount'] as int?;
          String? orderDetails = data['details'] as String?;
          String? orderId = data['orderId'] as String?;
          bool selectedFlat = data['selectedFlat'] as bool? ?? false;
          if (orderName != null && !selectedFlat && orderPlace != null && orderAmount != null && orderDetails != null && orderId != null) {
            updatedOrderName.add(orderName);
            updatedOrderPlace.add(orderPlace);
            updatedOrderAmount.add(orderAmount);
            updatedOrderDetails.add(orderDetails);
            updatedOrderId.add(orderId);
          }
        }
      }
      setState(() {
        orderName = updatedOrderName;
        orderPlace = updatedOrderPlace;
        orderAmount = updatedOrderAmount;
        orderDetails = updatedOrderDetails;
        orderIdList = updatedOrderId;
      });
    } else {
      print('No order found!');
    }
  }

  Future<void> updateFirestore(int index, String newName, int newAmount, String newPlace, String newDetails, List<String> OrderId) async {
    try {
      CollectionReference orders = FirebaseFirestore.instance.collection('orders');
      String orderId = OrderId[index];
      await orders.doc(orderId).update({
        'name': newName,
        'amount': newAmount,
        'place': newPlace,
        'details': newDetails,
      });
      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> deleteItemFromFirestore(String orderId) async {
    try {
      CollectionReference orders = FirebaseFirestore.instance.collection('orders');
      await orders.doc(orderId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}

class OrderItem extends StatefulWidget {
  final String listId;
  final String orderName;
  final int orderAmount;
  final String orderPlace;
  final String orderDetails;
  final List<String> orderIdList;
  final Function(String, int, String, String) onUpdate;
  final Function onDelete;

  const OrderItem(
      {Key? key,
        required this.listId,
        required this.orderName,
        required this.orderAmount,
        required this.orderPlace,
        required this.orderDetails,
        required this.orderIdList,
        required this.onUpdate,
        required this.onDelete})
      : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isEditing = false;
  late TextEditingController productNameController;
  late TextEditingController productAmountController;
  late TextEditingController productPlaceController;
  late TextEditingController productDetailsController;
  String listId = "";

  @override
  void initState() {
    super.initState();
    listId = widget.listId;
    productNameController = TextEditingController(text: widget.orderName);
    productAmountController = TextEditingController(text: widget.orderAmount.toString());
    productPlaceController = TextEditingController(text: widget.orderPlace);
    productDetailsController = TextEditingController(text: widget.orderDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      enabled: isEditing,
                      controller: productNameController,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(labelText: 'Ürün'),
                    ),
                    TextField(
                      enabled: isEditing,
                      controller: productAmountController,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(labelText: 'Adet'),
                    ),
                    TextField(
                      enabled: isEditing,
                      controller: productPlaceController,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(labelText: 'Yer'),
                    ),
                    if (widget.orderDetails.isNotEmpty)
                      TextField(
                        enabled: isEditing,
                        controller: productDetailsController,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        decoration: InputDecoration(labelText: 'Detaylar'),
                        maxLines: null, // Allow unlimited lines for details
                      ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isEditing)
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
                if (isEditing)
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      widget.onUpdate(
                        productNameController.text,
                        int.parse(productAmountController.text),
                        productPlaceController.text,
                        productDetailsController.text,
                      );
                      setState(() {
                        isEditing = false;
                      });

                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderViewScreen(listId: listId),
                        ),
                      );
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Show delete confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Emin Misiniz?'),
                          content: Text('Bu ürünü listenizden çıkarmak istediğinize emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('İptal'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onDelete();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderViewScreen(listId: listId),
                                  ),
                                );
                              },
                              child: Text('Sil'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



