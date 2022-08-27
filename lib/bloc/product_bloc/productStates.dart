part of 'productBloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class LoadingState extends ProductState {}

class AddedToCartState extends ProductState {}

class ProductsLoadedState extends ProductState {
  final List<Product> currentProductList;
  final int page;
  final int totalProducts;
  final int totalCartItems;

  const ProductsLoadedState(
      {required this.currentProductList,
      required this.page,
      required this.totalProducts,
      required this.totalCartItems});
}
