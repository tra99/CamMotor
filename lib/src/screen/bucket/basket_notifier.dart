import 'package:flutter/foundation.dart';

class BasketNotifier {
  static final ValueNotifier<int> basketCount = ValueNotifier<int>(0);

  static void updateCount(int count) {
    basketCount.value = count;
  }

  static void incrementCount(int increment) {
    basketCount.value += increment;
  }

  static void decrementCount(int decrement) {
    basketCount.value -= decrement;
  }
}
