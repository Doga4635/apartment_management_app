import 'package:apartment_management_app/screens/dagitim_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../utils/utils.dart';
import 'ana_menü_yardım_screen.dart';

class FlatScreen extends StatefulWidget {

  final String apartmentId;
  final String floorNo;
  final String flatNo;
  final String flatId;

  const FlatScreen({Key? key, required this.apartmentId, required this.floorNo, required this.flatNo, required this.flatId }) : super(key: key);

  @override
  FlatScreenState createState() => FlatScreenState();
}

class FlatScreenState extends State<FlatScreen> {
  List<OrderModel> orders = [];
  late String _currentDay;
  bool _isLoading = true;
  double totalPrice = 0;
  double givenAmount = 0;
  double? balance = 0;
  double? doormanBalance = 0;
  bool isEditing = false;
  int _cursorPosition = 0;
  bool _isDelivered = false;


  @override
  void initState() {
    super.initState();
    _updateCurrentDay();
    fetchOrders(widget.apartmentId, widget.floorNo, widget.flatNo);

  }

  void _updateCurrentDay() {
    final now = DateTime.now();
    _currentDay = getDayOfWeek(now.weekday);
    setState(() {
      _isDelivered = false; // Reset delivery status when updating the current day
    });
  }

  Future<void> fetchOrders(String apartmentId, String floorNo, String flatNo) async {
    String? flatId;

    try {
      QuerySnapshot flatSnapshot = await FirebaseFirestore.instance
          .collection('flats')
          .where('apartmentId', isEqualTo: apartmentId)
          .where('floorNo', isEqualTo: floorNo)
          .where('flatNo', isEqualTo: flatNo)
          .get();

      if (flatSnapshot.docs.isNotEmpty) {
        flatId = flatSnapshot.docs.first['flatId'];
      }
    } catch (error) {
      showSnackBar('Kullanıcı id si alınamadı.');
    }

    balance = await getBalanceWithFlatId(flatId);
    doormanBalance = balance!*(-1);

    orders.clear();
    try {
      final QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('apartmentId', isEqualTo: apartmentId)
          .where('floorNo', isEqualTo: floorNo)
          .where('flatNo', isEqualTo: flatNo)
          .where('days', arrayContains: _currentDay)
          .where('isDelivered', isEqualTo: false)
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        orders = orderSnapshot.docs.map((doc) {
          return OrderModel(
              listId: doc['listId'] ?? '',
              orderId: doc['orderId'] ?? '',
              productId: doc['productId'] ?? '',
              name: doc['name'] ?? '',
              amount: doc['amount'] ?? '',
              price: doc['price'] ?? '',
              details: doc['details'] ?? '',
              place: doc['place'] ?? '',
              days: List<String>.from(doc['days']),
              flatId: doc['flatId'] ?? '',
              isDelivered: doc['isDelivered'] ?? false,
              apartmentId: apartmentId,
              floorNo: floorNo,
              flatNo: flatNo);

        }).toList();
      } else {
        print('No documents found for the current user.');
      }

      for (var order in orders) {
        totalPrice += (order.amount) * (order.price);
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchBalance(String flatId) async {
    try {
      // Perform your calculations
      double newBalance = totalPrice - givenAmount - balance!;
      double flatBalance = newBalance * (-1);

      // Update the balance in Firestore
      await FirebaseFirestore.instance
          .collection('flats')
          .doc(flatId)
          .update({'balance': flatBalance});

setState(() {
  balance = flatBalance;
  doormanBalance = balance! * (-1);
});

      print('Balance updated successfully in Firestore.');
    } catch (error) {
      print('Error fetching or updating balance: $error');
    }
  }

  void markOrdersAsDelivered() async {
    for (var order in orders) {
         await FirebaseFirestore.instance
            .collection('orders')
             .doc(order.orderId)
          .update({'isDelivered': true});
        }
    }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when user taps anywhere on the screen
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Daire ${widget.flatNo} Siparişleri'),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {

              storeBalance();

              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DagitimScreen()),
              );
              },
          ),
        ),
        body: _isLoading == true
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        )
            : orders.isEmpty
            ? const Center(
          child: Text(
            'Bu dairenin hiç siparişi bulunmamaktadır.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: orders.map((order) {
                  // Define a TextEditingController for each TextField
                  TextEditingController controller = TextEditingController(text: order.amount.toString());
                  final selection = controller.selection;
                  _cursorPosition = selection.start;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 130, // Adjust the width of the leading widget as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.name, style: const TextStyle(fontSize: 18)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      enabled: isEditing, // Enable/disable editing based on the flag
                                      controller: controller,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        labelText: 'Adet',
                                      ),
                                      onChanged: (value) {
                                        // Update the order amount when the TextField value changes
                                        setState(() {
                                          order.amount = int.tryParse(value)!;
                                          totalPrice = calculateTotalPrice();
                                        });

                                        // Restore cursor position
                                        controller.selection = TextSelection.collapsed(offset: _cursorPosition);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle the editing mode
                                        isEditing = !isEditing;
                                      });
                                    },
                                    child: const Icon(Icons.edit), // Replace this with your pencil icon
                                  ),
                                ],
                              ),
                              Text('${order.price} TL\n${order.details}', style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 50,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${order.price * order.amount} TL', style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 20.0, right: 150.0, top: 16.0),
              child: Text(
                'Toplam: $totalPrice TL',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Verilen Tutar',
                ),
                onChanged: (value) {
                  setState(() {
                    givenAmount = double.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                fetchBalance(widget.flatId); // Call fetchBalance with the flatId
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // background color
              ),
              child: const Text('Bakiye Hesapla', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bakiye: ${doormanBalance!.abs()} TL',
                style: TextStyle(
                  fontSize: 16,
                  color: doormanBalance!.isNegative ? Colors.red : Colors.green,
                ),
              ),
            ),
          ],
        ),


        bottomNavigationBar: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  markOrdersAsDelivered();
                  setState(() {
                    _isDelivered = true;
                  });
                  fetchOrders(widget.apartmentId, widget.floorNo, widget.flatNo);
                },
                tooltip: 'Teslim Edildi',
                backgroundColor: Colors.teal,
                label: Text(_isDelivered ? "Teslim Edildi" : "Teslim Et", style: TextStyle(color: Colors.white),),
                icon: Icon(
                  _isDelivered ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const YardimScreen()),
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
        ),
    );
    }


  double calculateTotalPrice() {
    double total = 0;
    for (var order in orders) {
      total += order.amount * order.price;
    }
    return total;
  }


  Future<void> storeBalance() async {
    try {
      // Update the balance in Firestore when leaving the page
      await FirebaseFirestore.instance
          .collection('flats')
          .doc(widget.flatId)
          .update({'balance': balance});
      print('Balance stored successfully in Firestore.');
    } catch (error) {
      print('Error storing balance: $error');
    }
  }
}

