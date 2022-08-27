import 'package:manek_demo/utils/import_helper.dart';

part 'cartEvents.dart';
part 'cartStates.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState()) {
    final dbHelper = DatabaseHelper.instance;
    List<CartItem> cartItems = [];
    int totalUnitsOfItems = 0, grandTotal = 0;

    Future<void> fetchTotalCartItems() async {
      Map result = await dbHelper.getTotalCartItems();
      totalUnitsOfItems = result['totalQuantity'] ?? 0;
    }

    getCartItems() async {
      try {
        cartItems = await dbHelper.getCartItemList();
        int total = 0;

        for (var item in cartItems) {
          total += item.quantity! * item.price!;
        }
        grandTotal = total;

        await fetchTotalCartItems();
      } catch (e) {
        throw (e);
      }
    }

    deleteItem(itemId) async {
      try {
        await dbHelper.deleteCartItem(itemId);
      } catch (e) {
        throw (e);
      }
    }

    on<GetAllCartItemsEvent>((event, emit) async {
      emit(CartLoadingState());
      await getCartItems();

      emit(CartItemsLoadedState(
          cartItems: cartItems,
          totalItems: totalUnitsOfItems,
          grandTotal: grandTotal));
    });

    on<DeleteCartItemEvent>((event, emit) async {
      emit(CartInitialState());
      await deleteItem(event.itemId);
      await getCartItems();
      emit(CartItemsLoadedState(
          cartItems: cartItems,
          totalItems: totalUnitsOfItems,
          grandTotal: grandTotal));
    });
  }
}
