import 'package:flutter/foundation.dart';

import '../model/pagination.dart';
import '../services/pagination.dart';

class StudentProvider extends ChangeNotifier {
  List<Model> modelData = [];
  int currentPage = 0;
  int pageSize = 15;
  bool isLoading = false;
  List<Model> cachedData = [];

  Future<void> fetchStudentData(int page, int pageSize) async {
  isLoading = true;
  notifyListeners();

  try {
    final studentService = StudentService();

    // Only fetch data if cachedData is empty or requested page is greater than current page
    if (cachedData.isEmpty || page > currentPage) {
      final students = await studentService.fetchStudentData(page, pageSize);

      if (students.isNotEmpty) {
        if (page == 1) {
          modelData.clear(); // Clear existing data only when fetching the first page
        }
        modelData.addAll(students);
        currentPage = page;
      }
    }
  } catch (e) {
    // print("Error: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  // Add a method to fetch initial data
  Future<void> fetchInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      modelData.clear(); // Clear existing data
      currentPage = 1; // Reset page
      await fetchStudentData(currentPage, pageSize); // Fetch initial data
    } catch (e) {
      // print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
class CopyProvider extends ChangeNotifier {
  List<Model> modelData = [];
  int currentPage = 0;
  int pageSize = 12;
  bool isLoading = false;
  List<Model> cachedData = [];

  Future<void> fetchCopyData(int page, int pageSize) async {
  isLoading = true;
  notifyListeners();

  try {
    final copyService = CopyService();

    // Only fetch data if cachedData is empty or requested page is greater than current page
    if (cachedData.isEmpty || page > currentPage) {
      final students = await copyService.fetchCopyData(page, pageSize);

      if (students.isNotEmpty) {
        if (page == 1) {
          modelData.clear(); // Clear existing data only when fetching the first page
        }
        modelData.addAll(students);
        currentPage = page;
      }
    }
  } catch (e) {
    // print("Error: $e");
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  // Add a method to fetch initial data
  Future<void> fetchInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      modelData.clear(); // Clear existing data
      currentPage = 1; // Reset page
      await fetchCopyData(currentPage, pageSize); // Fetch initial data
    } catch (e) {
      // print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}