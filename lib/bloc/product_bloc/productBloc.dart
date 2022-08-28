import 'package:manek_demo/utils/import_helper.dart';

part 'productEvents.dart';
part 'productStates.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(LoadingState()) {
    final dbHelper = DatabaseHelper.instance;
    Service service = Service();
    int offset = 0, limit = 5, totalProducts = 0, totalCartItems = 0;
    List<Product> currentProdList = [];

    Future<List<Product>> queryLocal(offset) async {
      List<Product> products = await dbHelper.queryLimitProducts(offset, limit);
      return products;
    }

    Future<void> fetchTotalCartItems() async {
      Map result = await dbHelper.getTotalCartItems();
      totalCartItems = result['totalQuantity'] ?? 0;
    }

    getProducts() async {
      try {
        List<Product> prodList = [];
        totalProducts = await dbHelper.getProductCount();


        if (totalProducts == 0) {
          await service.getProductsList().then((respObj) {
            prodList = respObj;
            totalProducts = prodList.length;
            var temp = prodList.map((e) {
              dbHelper.insertProduct(e);
            });
            print(temp);
          });
        }
        await fetchTotalCartItems();
        currentProdList = await queryLocal(offset);
      } catch (e) {
        throw e;
      }
    }

    on<GetProductsEvent>((event, emit) async {
      emit(LoadingState());
      await getProducts();
      await fetchTotalCartItems();
      emit(ProductsLoadedState(
          currentProductList: currentProdList,
          page: offset,
          totalCartItems: totalCartItems,
          totalProducts: totalProducts));
    });

    on<GetNextProductsEvent>((event, emit) async {
      int tempOffset = offset + limit;
      if (tempOffset < totalProducts) {
        emit(LoadingState());
        offset += limit;
        currentProdList = await queryLocal(offset);
        await fetchTotalCartItems();
        emit(ProductsLoadedState(
            currentProductList: currentProdList,
            page: offset,
            totalCartItems: totalCartItems,
            totalProducts: totalProducts));
      }
    });

    on<GetPrevProductsEvent>((event, emit) async {
      if (offset > 0) {
        emit(LoadingState());
        offset -= limit;
        currentProdList = await queryLocal(offset);
        await fetchTotalCartItems();
        emit(ProductsLoadedState(
            currentProductList: currentProdList,
            page: offset,
            totalCartItems: totalCartItems,
            totalProducts: totalProducts));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      emit(ProductInitialState());
      int isExists = await dbHelper.isExistsIncart(event.product.id);
      if (isExists == 0) {
        var cartItem = {'id': event.product.id, 'quantity': 1};
        Cart item = Cart.fromJson(cartItem);
        await dbHelper.insertCartItem(item);
      } else {
        await dbHelper.updateCartItem(event.product.id!);
      }
      await fetchTotalCartItems();
      emit(AddedToCartState());

      emit(ProductsLoadedState(
          totalCartItems: totalCartItems,
          currentProductList: currentProdList,
          page: offset,
          totalProducts: totalProducts));
    });
  }
}
