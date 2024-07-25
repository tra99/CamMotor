import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cammotor_new_version/src/model/order_detail.dart';
import 'package:cammotor_new_version/src/providers/real_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/store_basket.dart';
import '../bucket/basket_notifier.dart';
import '../bucket/bucket_screen.dart';
import 'package:http/http.dart' as http;

class RealProduct extends StatefulWidget {
  final int subcategoryID;

  const RealProduct({super.key, required this.subcategoryID});

  @override
  State<RealProduct> createState() => _RealProductState();
}
class _RealProductState extends State<RealProduct> with AutomaticKeepAliveClientMixin{
  late ScrollController _scrollController;
  late SearchController searchController;
  late TextEditingController textEditingController = TextEditingController();

  int basketCount = 0;
  int qty = 0;
  bool _firstItemAdded = false;
  String? _orderId; 

  void _onIncreaseQuantity(String productName) {
    setState(() {
      qty++;
    });
    _updateBasketItemQuantity(productName, qty);
  }

  void _onDecreaseQuantity(String productName) {
    if (qty > 0) {
      setState(() {
        qty--;
      });
      _updateBasketItemQuantity(productName, qty);
    }
  }
    void updateQuantity(int newQuantity) {
      setState(() {
        qty = newQuantity;
      });
      
    }

  Future<void> _saveBasketItem(int productId, String productName, int quantity, String img, double price) async {
    final prefs = await SharedPreferences.getInstance();
    final basketItems = prefs.getStringList('basketItems') ?? [];
    bool itemExists = false;

    for (int i = 0; i < basketItems.length; i++) {
      final item = jsonDecode(basketItems[i]) as Map<String, dynamic>;
      if (item['productId'] == productId) {
        // Update the quantity of the existing product
        item['quantity'] += quantity;
        basketItems[i] = jsonEncode(item);
        itemExists = true;
        break;
      }
    }

    if (!itemExists) {
      basketItems.add(jsonEncode({
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'img': img,
        'price': price,  // Include the price
      }));
    }
    await prefs.setStringList('basketItems', basketItems);
    await _loadBasketCount();
  }



  Future<void> _loadBasketCount() async {
    final prefs = await SharedPreferences.getInstance();
    final basketItems = prefs.getStringList('basketItems') ?? [];
    int totalCount = 0;

    for (var item in basketItems) {
      final decodedItem = jsonDecode(item) as Map<String, dynamic>;
      totalCount += decodedItem['quantity'] as int;
    }

    setState(() {
      basketCount = totalCount;
    });
  }
  
  @override
  void initState() {
    super.initState();
    searchController = SearchController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBasketCount();
      Provider.of<RealProductProvider>(context, listen: false).fetchInitialData(widget.subcategoryID);
    });
  }

  Future<void> fetchInitialData(int subcategoryID) async {
    final provider = Provider.of<RealProductProvider>(context, listen: false);
    try {
      await provider.fetchInitialData(subcategoryID);
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _incrementBasketCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      basketCount++;
      prefs.setInt('basketCount', basketCount);
    });
  }

  void _updateBasketItemQuantity(String productName, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final basketItems = prefs.getStringList('basketItems') ?? [];
    final updatedBasketItems = basketItems.map((item) {
    final decodedItem = jsonDecode(item) as Map<String, dynamic>;
      if (decodedItem['productName'] == productName) {
        decodedItem['quantity'] = quantity;
      }
      return jsonEncode(decodedItem);
    }).toList();
    await prefs.setStringList('basketItems', updatedBasketItems);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasketPage()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: BasketNotifier.basketCount,
                    builder: (context, basketCount, child) {
                      return basketCount > 0
                          ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '$basketCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<RealProductProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    updateProductList(value, provider);
                  },
                  decoration: InputDecoration(
                    hintText: 'ស្វែងរកគ្រឿងបន្លាស់',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 217, 217, 217),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!provider.isLoading &&
                        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      print('ScrollNotification triggered, fetching more data...');
                      provider.fetchProductData(
                        provider.currentPage + 1,
                      );
                      return true;
                    }
                    return false;
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: provider.filteredProductData.length, 
                    itemBuilder: (context, index) {
                      final product = provider.filteredProductData[index]; 
                      if (product.subcategoryID != widget.subcategoryID) {
                        return const SizedBox.shrink(); 
                      }
                      return GestureDetector(
                        onTap: () {
                         _showMyDialog(
                          product.productId,  
                          product.name,
                          '${dotenv.env['BASE_URL']}/storage/${product.img}',
                          product.instock.toString(),
                          product.qty,
                          product.discount.toDouble(),
                          product.yearID,
                          product.modelID,
                          product.price.toString(),
                          product.resourceID.toString(),
                          updateQuantity,
                        );
                        },
                        child: Theme(
                          data: ThemeData(dialogBackgroundColor: Colors.white),
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 34,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 65, 62, 62),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Center(
                                          child: Text(
                                            "${product.price} \$",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 2,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          '${dotenv.env['BASE_URL']}/storage/${product.img}',
                                          maxWidth: 200,
                                          maxHeight: 200),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 2, bottom: 10),
                                        child: Center(
                                          child: Text(
                                            product.name,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 65, 62, 62),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(14),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: InkWell(
                                          onTap: () {
                                            // onAddToCart(productName);
                                          },
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (provider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  void updateProductList(String value, RealProductProvider provider) {
    if (value.isEmpty) {
      provider.resetProductData(); 
    } else {
      provider.filterProductData(value.toLowerCase()); 
    }
  }

  void _scrollListener() {
    final provider = Provider.of<RealProductProvider>(context, listen: false);
    if (!provider.isLoading && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('ScrollListener triggered, fetching more data...');
      provider.fetchProductData(widget.subcategoryID);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showMyDialog(
    int productId, 
    String productName,
    String img,
    String instock,
    int initialQuantity,
    double discount,
    int yearID,
    int modelID,
    String price,
    String resourceID,
    Function(int) updateQtyCallback,
  ) async {
    int dialogQty = 1;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: Theme(
            data: ThemeData(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Center(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 92, 88, 88),
                  ),
                ),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Image.network(
                              img,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '• In Stock: $instock',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• Available Quantity: $initialQuantity',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• Discount: \$ $discount',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• Year: $yearID',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 66, 53, 53),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          if (dialogQty > 0) {
                                            dialogQty--;
                                            updateQtyCallback(dialogQty);
                                          }
                                        });
                                      },
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '$dialogQty',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          dialogQty++;
                                          updateQtyCallback(dialogQty);
                                        });
                                      },
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '\$ $price',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 92, 88, 88),
                      ),
                      onPressed: () {
                        updateQtyCallback(dialogQty);
                        _saveBasketItem(productId, productName, dialogQty, img, double.parse(price)); // Ensure price is passed as a double

                        if (!_firstItemAdded) {
                          _fetchDataStoreBasketModel(dialogQty);
                          setState(() {
                            _firstItemAdded = true;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('ដាក់កន្ត្រក', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  bool get wantKeepAlive => true;

  final TextEditingController _totalController = TextEditingController();
  String? _result = '';

  List<OrderDetailModel> _orderList = [];

  Future<void> _fetchDataStoreBasketModel(int subcategoryID) async {
    try {
      final response = await fetchDataStoreBasketModel(subcategoryID);
      print('Server response: $response'); 

      if (response.containsKey('data')) {
        final Map<String, dynamic> responseData = response;
        final orderData = responseData['data'];
        if (orderData != null) {
          final orderId = orderData['id'].toString();
          print('Order data: $orderData'); 
          print('Extracted order ID: $orderId'); 
          setState(() {
            _orderId = orderId;
          });
          await _storeOrderId(orderId);
        } else {
          print('Order data is null');
          setState(() {
            _orderId = null;
          });
        }
      } else if (response.containsKey('orderId')) {
        final orderId = response['orderId'].toString();
        setState(() {
          _orderId = orderId;
        });
        await _storeOrderId(orderId);
      } else {
        print('Unexpected response structure');
        setState(() {
          _orderId = null;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _storeOrderId(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
  }

  Future<void> createOrderItem(
    int quantityOrder, double total, int orderID, int productID) async {
    final url = 'http://68.183.234.112:2025/api/order_items';
    print('Sending POST request to $url with data: quantity_order=$quantityOrder, total=$total, orderID=$orderID, productID=$productID');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity_order': quantityOrder,
        'total': total,
        'orderID': orderID,
        'productID': productID,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to create order item: ${response.body}');
    } else {
      print('Order item created successfully');
    }
  }
  
}


