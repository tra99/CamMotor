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
    print("Error: $e");
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
      print("Error: $e");
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
    print("Error: $e");
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
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// class CopyProvider with ChangeNotifier {
//   final CopyService _service = CopyService();
//   List<Model> studentData = [];
//   int currentPage = 1;
//   int pageSize = 12;
//   bool isLoading = false;
//   dynamic error;
//   bool hasMoreData = true;


// Future<void> fetchData() async {
//   isLoading = true;
//   notifyListeners();

//   try {
//     final newData = await _service.fetchStudentData(currentPage, pageSize);
  
//     if (newData.isEmpty) {
//       // Handle the case when there is no data to load
//       hasMoreData = false;
//     } else {
//       for (final model in newData) {
//         if (!studentData.contains(model)) {
//           studentData.add(model);
//         }
//       }
//       currentPage++;
//       hasMoreData = newData.isNotEmpty;
//     }
//   } catch (e) {
//     error = e;
//     print("Error: $e");
//   } finally {
//     isLoading = false;
//     notifyListeners();
//   }

// }

//   // Add a method to fetch initial data
//   Future<void> fetchInitialData() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       await fetchData(); // Fetch initial data without clearing existing data
//     } catch (e) {
//       print("Error: $e");
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

  
// }

