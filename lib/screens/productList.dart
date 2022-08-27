import 'package:manek_demo/utils/import_helper.dart';
export 'dart:math';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    super.initState();
    productBloc.add(const GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
        bloc: productBloc,
        buildWhen: (prevState, state) {
          if (state is ProductsLoadedState) {
            return true;
          }
          if (state is LoadingState) {
            return true;
          }
          if (state is AddedToCartState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(milliseconds: 700),
                backgroundColor: kPrimaryColor,
                content: Text(
                  "Added to cart!",
                  style: TextStyle(
                      color: kWhiteColor, fontFamily: font, fontSize: 17),
                )));
            return false;
          }

          return false;
        },
        builder: (context, state) {
          if (state is ProductsLoadedState) {
            return Scaffold(
                appBar: callAppBar(context, state),
                body: Container(
                    height: MediaQuery.of(context).size.height * 1.2,
                    color: kWhiteColor,
                    child: OrientationBuilder(builder: (context, orientation) {
                      return Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () => productBloc
                                      .add(const GetPrevProductsEvent()),
                                  icon: const Icon(Icons.arrow_back_ios)),
                              Text(
                                  "Products ${state.page + 1} - ${min(state.page + 5, state.totalProducts)}"),
                              IconButton(
                                  onPressed: () => productBloc
                                      .add(const GetNextProductsEvent()),
                                  icon: const Icon(Icons.arrow_forward_ios))
                            ]),
                        Expanded(
                            child: GridView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 15),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            childAspectRatio:
                                orientation == Orientation.portrait
                                    ? (1 / 1.4)
                                    : (1 / 1),
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 20.0,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: state.currentProductList.length,
                          itemBuilder: (context, index) {
                            Product element = state.currentProductList[index];
                            return Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: kWhiteColor,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color(0xffadadad),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 120,
                                        margin: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Center(
                                          child: Image.network(
                                              element.featured_image ?? ""),
                                        )),
                                    const SizedBox(height: 10),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Text('\$ ${element.price}',
                                            style: const TextStyle(
                                                fontFamily: "Lato",
                                                fontWeight: FontWeight.bold,
                                                color: kBlackColor,
                                                fontSize: 20))),
                                    const SizedBox(height: 10),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Text(
                                                    //  element.title!,
                                                    element.title!.length > 25
                                                        ? "${(element.title!).substring(0, 25)}..."
                                                        : element.title!,
                                                    style: const TextStyle(
                                                        color: kTertiaryColor,
                                                        fontFamily: "Lato",
                                                        fontSize: 15))),
                                            IconButton(
                                                icon: const Icon(
                                                    Icons.shopping_cart,
                                                    color: kTertiaryColor,
                                                    size: 23),
                                                onPressed: () {
                                                  productBloc.add(
                                                      AddToCartEvent(
                                                          product: element,
                                                          totalCartItems: state
                                                              .totalCartItems));
                                                })
                                          ],
                                        )),
                                    const SizedBox(height: 10),
                                  ],
                                ));
                          },
                        ))
                      ]);
                    })));
          }

          return Scaffold(
              appBar: callAppBar(context, state),
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()),
              ));
        });
  }

  PreferredSizeWidget callAppBar(context, state) {
    return AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text("Shopping Mall"),
        titleTextStyle: const TextStyle(
            color: kWhiteColor,
            fontSize: 19,
            fontFamily: "Lato",
            fontWeight: FontWeight.bold),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, size: 30),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyCart(),
                    ));
                productBloc.add(const GetProductsEvent());
              },
            ),
            Positioned(
                left: 25,
                top: 3,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    state is ProductsLoadedState
                        ? state.totalCartItems.toString()
                        : '0',
                    style: const TextStyle(
                        fontFamily: font, fontSize: 11, color: kWhiteColor),
                  )),
                ))
          ]),
          const SizedBox(
            width: 15,
          )
        ]);
  }
}
