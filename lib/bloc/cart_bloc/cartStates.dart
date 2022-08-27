part of 'cartBloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}


class CartItemsLoadedState extends CartState {
  final List<CartItem> cartItems;
  final int totalItems;
  final int grandTotal;

  const CartItemsLoadedState({required this.cartItems, required this.totalItems, required this.grandTotal});
}
