import 'package:manek_demo/utils/import_helper.dart';

class Network {
  static Future<bool> checkInternetConnection() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // }
    return false;
  }
}
