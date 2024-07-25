import 'package:flutter/material.dart';
import '../model/real_product.dart';
import '../services/real_product.dart';

class RealProductProvider extends ChangeNotifier {
  List<RealProductModel> productData = [];
  List<RealProductModel> filteredProductData = [];
  int currentPage = 1;
  final int pageSize = 12;
  bool isLoading = false;
  final RealProductService productService = RealProductService();

  void filterProductData(String query) {
    filteredProductData = productData
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void resetProductData() {
    filteredProductData = List.from(productData);
    notifyListeners();
  }

  Future<void> fetchProductData(int subcategoryID) async {
    if (isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final products = await productService.fetchProductData(currentPage, pageSize, subcategoryID);

      // Check for duplicate products
      final newProducts = products.where((newProduct) =>
          !productData.any((existingProduct) => newProduct.productId == existingProduct.productId)).toList();

      if (newProducts.isNotEmpty) {
        productData.addAll(newProducts);
        filteredProductData.addAll(newProducts); // Update filtered data after fetching new products
        currentPage++;
      }
    } catch (e) {
      print("Error fetching product data: $e");
      // Handle error as needed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInitialData(int subcategoryID) async {
    isLoading = true;
    notifyListeners();

    try {
      productData.clear();
      filteredProductData.clear();
      currentPage = 1;

      final products = await productService.fetchProductData(currentPage, pageSize, subcategoryID);
      productData.addAll(products);
      filteredProductData.addAll(products);
      currentPage++; // Increment after initial data fetch
    } catch (e) {
      print("Error fetching initial data: $e");
      // Handle errors as needed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
