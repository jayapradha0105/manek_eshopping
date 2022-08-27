import 'package:manek_demo/utils/import_helper.dart';
import 'package:http/http.dart' as http;

class Service {
  Future<List<Product>> getProductsList() async {
    try {
      final response = await http.get(Uri.parse(getProductsUrl), headers: {
        'token':
            'eyJhdWQiOiI1IiwianRpIjoiMDg4MmFiYjlmNGU1MjIyY2MyNjc4Y2FiYTQwOGY2MjU4Yzk5YTllN2ZkYzI0NWQ4NDMxMTQ4ZWMz'
      });
      final data = json.decode(response.body);
      print(data['data']);
      List<Product> productList = [];
      productList = data['data']
          .map((tagJson) => Product.fromJson(tagJson))
          .cast<Product>()
          .toList();
      return productList;
    } catch (e) {
      throw e;
    }
  }
}
