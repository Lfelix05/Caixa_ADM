import 'package:flutter/material.dart';
import 'package:caixa/view/home.dart';
import 'package:caixa/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.loadData(); // Carregar dados salvos
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}
