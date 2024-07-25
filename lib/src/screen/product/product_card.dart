import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/product.dart';
import 'product_detail.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(String, int, String) onAddToCart;
  final Function(int) updateQuantity;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAddToCart,
    required this.updateQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMyDialog(
          context,
          product.name,
          '${dotenv.env['BASE_URL']}/storage/${product.img}',
          product.instock.toString(),
          product.qty.toString(),
          product.discount.toDouble(),
          product.yearID,
          product.modelID,
          product.price.toString(),
          product.resourceID.toString(),
          updateQuantity,
        );
      },
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
                        style: const TextStyle(color: Colors.white),
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
                    maxHeight: 200,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      product.name,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 10,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          size: 10,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          onAddToCart(product.name, 1, product.img);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(
    BuildContext context,
    String title,
    String imageUrl,
    String productDesc,
    String quantity,
    double discount,
    int yearId,
    int modelId,
    String price,
    String resourceId,
    Function(int) updateQuantity,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductDialog(
          title: title,
          imageUrl: imageUrl,
          productDesc: productDesc,
          quantity: quantity,
          discount: discount,
          yearId: yearId,
          modelId: modelId,
          price: price,
          resourceId: resourceId,
          updateQuantity: updateQuantity,
        );
      },
    );
  }
}
