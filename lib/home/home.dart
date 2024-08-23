import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListTile _drawerItem(String name) => ListTile(
    title: Text(name),
    onTap: () => context.go('/${name.replaceAll(' ', '').toLowerCase()}'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Playground'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(children: [
          const DrawerHeader(child: Text('Demo List')),
          _drawerItem('Edge Track'),
          _drawerItem('Image Pinch Zoom'),
          _drawerItem('Image Drag Select'),
          _drawerItem('Arc Color Board'),
          _drawerItem('Blank'),
        ]),
      ),
      body: Center(child: Image.asset('assets/frieren-600x945.jpg')),
    );
  }
}
