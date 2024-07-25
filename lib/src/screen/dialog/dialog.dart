import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDialog extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String productDesc;
  final String quantity;
  final double discount;
  final int yearId;
  final int modelId;
  final String price;
  final String resourceId;
  final Function(int) updateQuantity;

  const ProductDialog({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.productDesc,
    required this.quantity,
    required this.discount,
    required this.yearId,
    required this.modelId,
    required this.price,
    required this.resourceId,
    required this.updateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: 200,
              width: 200,
            ),
            Text('Description: $productDesc'),
            Text('Quantity: $quantity'),
            Text('Discount: $discount'),
            Text('Year: $yearId'),
            Text('Model: $modelId'),
            Text('Price: $price'),
            Text('Resource ID: $resourceId'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Add to Cart'),
          onPressed: () {
            updateQuantity(1);  // Adjust as needed for quantity management
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
