import 'package:cammotor_new_version/src/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<FetchOrder>(_onFetchOrder);
  }

  Future<void> _onFetchOrder(FetchOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    try {
      final response = await http.post(
        Uri.parse('http://68.183.234.112:2025/api/order/${event.userId}/user_status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final ordersResponse = OrdersResponse.fromJson(data);
        emit(OrderLoaded(ordersResponse.orders));
      } else {
        emit(OrderError('Failed to load orders'));
      }
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
