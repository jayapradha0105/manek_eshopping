import 'package:manek_demo/utils/import_helper.dart';
export 'package:intl/intl.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  CartBloc cartBloc = CartBloc();

  @override
  void initState() {
    super.initState();
    cartBloc.add(const GetAllCartItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<CartBloc, CartState>(
        bloc: cartBloc,
        buildWhen: (prevState, state) {
          if (state is CartItemsLoadedState) return true;
          if (state is CartInitialState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(milliseconds: 700),
                backgroundColor: kPrimaryColor,
                content: Text(
                  "Deleted item from cart!",
                  style: TextStyle(
                      color: kWhiteColor, fontFamily: font, fontSize: 17),
                )));
            return false;
          }
          return false;
        },
        builder: (context, state) {
          if (state is CartItemsLoadedState) {
             var formatter = NumberFormat('#,##,000');
            return Scaffold(
                appBar: callAppBar(context),
                bottomNavigationBar: Container(
                  color: kPrimaryColor.withOpacity(0.6),
                  height: 65,
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Items :  ${state.totalItems}",
                            style: const TextStyle(
                                color: kWhiteColor,
                                fontFamily: font,
                                fontSize: 17)),
                        Text("Grand Total :  \$${formatter.format(state.grandTotal)}",
                            style: const TextStyle(
                                color: kWhiteColor,
                                fontFamily: font,
                                fontSize: 17))
                      ]),
                ),
                backgroundColor: kWhiteColor,
                body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.cartItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          CartItem element = state.cartItems[index];
                          return Container(
                            height: 150,
                              margin:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Color(0xffadadad),
                                    blurRadius: 3.0,
                                  ),
                                ],
                              ),
                              child: Row(children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15)),
                                        color: kPrimaryColor.withOpacity(0.6)),
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Container(
                                       height: 130,
                                    width: 130,
                                      child: Center(
                                        child: Image.network(
                                            element.featured_image ?? ""
                                            // "http://205.134.254.135/~mobile/MtProject/uploads/product_image/1.jpg"),
                                            )))),
                                Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height:10),
                                            Text(
                                                element.title!.length > 25
                                                        ? "${(element.title!).substring(0, 25)}..."
                                                        : element.title!,
                                                // element.title!,
                                                style: const TextStyle(
                                                    color: kTertiaryColor,
                                                    fontFamily: font,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Price",
                                                    style: TextStyle(
                                                        color: kTertiaryColor,
                                                        fontFamily: font,
                                                        fontSize: 16)),
                                                Text(
                                                    '\$${element.price!.toString()}',
                                                    style: const TextStyle(
                                                        color: kTertiaryColor,
                                                        fontFamily: font,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Quantity",
                                                    style: TextStyle(
                                                        color: kTertiaryColor,
                                                        fontFamily: font,
                                                        fontSize: 16)),
                                                Text(
                                                    element.quantity!
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: kTertiaryColor,
                                                        fontFamily: font,
                                                        fontSize: 16)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        size: 25,
                                                        color: kTertiaryColor),
                                                    onPressed: () =>
                                                        cartBloc.add(
                                                            DeleteCartItemEvent(
                                                                itemId: element
                                                                    .id!)))
                                              ],
                                            )
                                          ],
                                        )))
                              ]));
                        })));
          }

          return Scaffold(
              appBar: callAppBar(context),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()),
              ));
        });
  }

  PreferredSizeWidget callAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text("My Cart"),
      titleTextStyle: const TextStyle(
          color: kWhiteColor,
          fontSize: 19,
          fontFamily: "Lato",
          fontWeight: FontWeight.bold),
    );
  }
}
