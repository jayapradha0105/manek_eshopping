part of 'productBloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductsEvent extends ProductEvent{
  const GetProductsEvent();
}

class GetNextProductsEvent extends ProductEvent{
  const GetNextProductsEvent();
}

class GetPrevProductsEvent extends ProductEvent{
  const GetPrevProductsEvent();
}


class AddToCartEvent extends ProductEvent{
  final Product product;
  final int totalCartItems;
  const AddToCartEvent({required this.product, required this.totalCartItems});
}
