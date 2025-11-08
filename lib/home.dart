import 'package:flutter/material.dart';
import 'produtos_tela.dart';
import 'vendas_tela.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 400,
          child: Card(
            elevation: 4.0,
            child: Padding(padding:   const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bem-vindo à Tela Inicial', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProdutosPage()));}, child: Text("Produtos", style: TextStyle(fontSize: 20),),
                  style: TextButton.styleFrom(minimumSize: Size(300, 50), backgroundColor: Colors.redAccent, foregroundColor: const Color.fromARGB(255, 0, 0, 0)),),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => VendasPage()));}, child: Text("Vendas", style: TextStyle(fontSize: 20),)
                  , style: TextButton.styleFrom(minimumSize: Size(300, 50), backgroundColor: Colors.yellowAccent, foregroundColor: const Color.fromARGB(255, 0, 0, 0)),),

                ],
              ),
            ),
          )
        )
      ),
    );
  }
}