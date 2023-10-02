import 'package:dtac_test/user/user_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:  Center(
        child:
        buildGestureDetector(title: "User List" , callback: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserMain()),
          );
        }),
      ),
    );
  }
  GestureDetector buildGestureDetector({String? title ,Function()? callback}) {
    return GestureDetector(
      onTap: (){
        callback?.call();
      },
      child: Container(
        margin: EdgeInsets.all(8),
        alignment: Alignment.center,
        height: 60,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Text(title ?? '' ,style:  const TextStyle(fontSize: 16 ,color: Colors.black),),
      ),
    );
  }
}
