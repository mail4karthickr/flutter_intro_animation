import 'package:flutter/material.dart';

import 'intro_page.dart';
  
void main() {
  runApp(
  const App(),
  );
}

class App extends StatelessWidget {
  const App({
  Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return const MaterialApp(
    home: HomePage(),
  );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> { 
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: IntroPage()
    );
  }
}

