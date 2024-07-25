import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class TestCardProduct extends StatefulWidget {
  const TestCardProduct({required Key key}) : super(key: key);

  @override
  State<TestCardProduct> createState() => _TestCardProductState();
}

class _TestCardProductState extends State<TestCardProduct> {
  List<String> price = [
    "1200 \$",
    "1500 \$",
    "1300 \$",
    "1400 \$",
    "1600 \$",
    "1700 \$",
    "1800 \$",
    "1900 \$",
    "2000 \$",
  ];

  List<String> image = [
    "assets/images/bmw.jpg",
    "assets/images/ducati.jpg",
    "assets/images/Honda.png",
    "assets/images/motor1.png",
    "assets/images/repair.png",
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
  ];

  List<String> productName = [
    "Product 1",
    "Product 2",
    "Product 3",
    "Product 4",
    "Product 5",
    "Product 6",
    "Product 7",
    "Product 8",
    "Product 9",
  ];
  List<String> description = [
    "hjdfhfdhdh",
    "hjdfhfdhdh",
    "hjdfhfdhdh",
  ];
  int badgeCount = 0;

  Map<String, int> selectedProducts = {}; // Store product names and quantities

  // Add or increment the quantity of a product
  void addToCart(String productName) {
    setState(() {
      if (selectedProducts.containsKey(productName)) {
        selectedProducts[productName] =
            (selectedProducts[productName] ?? 0) + 1; // Increment the quantity
      } else {
        selectedProducts[productName] =
            1; // Add the product with a quantity of 1
      }
      badgeCount++; // Increase the badge count
    });
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "កន្រ្តកទំនិញរបស់ខ្ញូំ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final productName = selectedProducts.keys.elementAt(index);
                  final quantity = selectedProducts[productName];
                  final itemPrice = int.parse(price[index]
                      .split(' \$')[0]); // Extract the price as an integer
                  final totalPrice = itemPrice * quantity!;

                  return Card(
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          image[index],
                          width: 100,
                        ),
                      ),
                      title: Text(productName),
                      subtitle: Text(
                        " x $quantity",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        "$totalPrice \$",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showProductDetail(BuildContext context, String productName,
      String image, List<String> description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetail(
          productName: productName,
          image: image,
          description: description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Card Product"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                _showCart(context);
              },
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.grey),
                badgeContent: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                child: const Icon(
                  BootstrapIcons.basket,
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: image.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: GridItems(
              price: price[index],
              image: image[index],
              productName: productName[index],
              onAddToCart: addToCart,
              quantity: selectedProducts[productName[index]] ?? 0,
              onTap: () {
                _showProductDetail(
                    context, productName[index], image[index], description);
              },
            ),
          );
        },
      ),
    );
  }
}

class GridItems extends StatelessWidget {
  final String price;
  final String image;
  final String productName;
  final Function onAddToCart;
  final int quantity;
  final VoidCallback onTap;

  const GridItems({
    Key? key,
    required this.price,
    required this.image,
    required this.productName,
    required this.onAddToCart,
    required this.quantity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 65, 62, 62),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 65, 62, 62),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      price,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Image.asset(
              image,
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(productName),
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
                          onAddToCart(productName);
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
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetail extends StatelessWidget {
  final String productName;
  final String image;
  final List<String> description;

  CardDetail({
    Key? key,
    required this.productName,
    required this.image,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              image,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              productName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: description.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          BulletedList(
                            listItems: description,
                            listOrder: ListOrder.ordered,
                          ),
                          
                        ],
                      )  
                    );
                }),
          ),
        ],
      ),
    );
  }
}

// const Text(
                          //   "• ",
                          //   style: TextStyle(
                          //     color: Colors.grey,
                          //     fontSize: 24,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // Expanded(
                          //   child: Text(
                          //     description[index],
                          //   ),
                          // ),
                          // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Expanded(
                      //       child: Text(
                      //         description[index],
                      //         style: const TextStyle(
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
