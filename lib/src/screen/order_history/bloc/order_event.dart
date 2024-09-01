part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class FetchOrder extends OrderEvent{
  final int userId;

  FetchOrder(this.userId);
}
