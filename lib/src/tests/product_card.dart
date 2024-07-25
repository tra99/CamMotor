import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
    "assets/images/bmw.jpg",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Product'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 60, 
          crossAxisSpacing: 10
        ),
        itemCount: price.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 400, // Set a fixed height for each ProductItem
            child: ProductItem(
              price: price[index],
              image: image[index],
              productName: productName[index],
            ),
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String price;
  final String image;
  final String productName;

  const ProductItem({
    Key? key,
    required this.price,
    required this.image,
    required this.productName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 30,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 117, 117, 117),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  price,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 100,
              child: Image.asset(image),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Container(
                    width: 40,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
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



