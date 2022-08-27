part of 'cartBloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetAllCartItemsEvent extends CartEvent{
  const GetAllCartItemsEvent();
}



class DeleteCartItemEvent extends CartEvent{
  final int itemId;
  const DeleteCartItemEvent({required this.itemId});
}