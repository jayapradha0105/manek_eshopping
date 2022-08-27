import 'package:manek_demo/utils/import_helper.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductList(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: kPrimaryColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // Image.asset(
          //   "assets/logo.svg",
          //   height: 100,
          //   width: 200,
          // ),
          Text("Manek Tech",
              style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 30,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("E-Commerce",
              style: TextStyle(
                color: kWhiteColor,
                                  fontFamily: "Lato",
                fontSize: 19,
              ))
        ],
      ),
    ));
  }
}
