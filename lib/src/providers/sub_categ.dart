import 'package:flutter/material.dart';
import '../model/sub_category.dart';
import '../services/sub_category.dart';

class SubCategoryProvider extends ChangeNotifier {
  List<SubCategoryModel> studentData = [];
  int currentPage = 1;
  int pageSize = 15;
  bool isLoading = false;
  String? error;

  Future<void> fetchSubCategoryData(int page, int pageSize, int categoryId) async {
    try {
      isLoading = true;
      notifyListeners();

      final studentService = SubCategoryService();
      final students = await studentService.fetchDataSubCategoryModel(page, pageSize, categoryId);

      if (students.isNotEmpty) {
        if (page == 1) {
          studentData.clear(); // Clear the data when it's the first page
        }
        studentData.addAll(students);
        currentPage = page;
        notifyListeners(); // Notify after adding new data
      }
    } catch (e) {
      // Handle error
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInitialData(int categoryId) async {
    try {
      isLoading = true;
      error = null; // Reset error on new fetch
      notifyListeners();

      studentData.clear(); // Clear the data when fetching initial data
      currentPage = 1;

      await fetchSubCategoryData(currentPage, pageSize, categoryId);
    } catch (e) {
      // Handle error
      error = "Failed to fetch initial data. Please try again."; // Provide a user-friendly error message
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
