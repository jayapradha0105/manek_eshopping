import 'package:manek_demo/utils/import_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductBloc>(
      create: (context) => ProductBloc(),
      child: MaterialApp(
      title: 'Manek Tech Demo',
      theme: ThemeData(
       
        primaryColor: kPrimaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    ));
  }
}
