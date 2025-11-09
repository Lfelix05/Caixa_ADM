import 'package:flutter/material.dart';
import 'package:caixa/database.dart';

import '../vendas.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  int _reloadKey = 0;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _precoVendaController = TextEditingController();
  final TextEditingController _dataVendaController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _prazoVendaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendas'),
      ),
      body: Database.vendas.isEmpty
          ? const Center(
              child: Text('Nenhuma venda registrada.'),
            )
          : ListView.builder(
              itemCount: Database.vendas.length,
              itemBuilder: (context, index) {
                final venda = Database.vendas[index];
                return ListTile(
                  title: Text(venda.nome_produto),
                  subtitle: Text(
                      'Preço: \$${venda.preco_venda.toStringAsFixed(2)}\nData da Venda: ${venda.data_venda.toLocal().toString().split(' ')[0]}\nCliente: ${venda.cliente}\nPrazo de Venda: ${venda.prazo_venda.toLocal().toString().split(' ')[0]}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(context: context,
               builder: (BuildContext context) {
                 return AlertDialog(
                   title: Text('Adicionar Venda'),
                   content: SingleChildScrollView(
                     child: Column(
                       children: [
                        Text('Formulário para adicionar uma nova venda.'),
                         TextField(
                           decoration: InputDecoration(labelText: 'Nome do Produto'),
                            controller: _namecontroller,
                         ),
                         TextField(
                           decoration: InputDecoration(labelText: 'Preço de Venda'),
                           keyboardType: TextInputType.number,
                           controller: _precoVendaController,
                         ),
                         TextField(
                           decoration: InputDecoration(labelText: 'Data da Venda'),
                           controller: _dataVendaController,  
                         ),
                         TextField(
                           decoration: InputDecoration(labelText: 'Cliente'),
                           controller: _clienteController,
                         ),
                         TextField(
                           decoration: InputDecoration(labelText: 'Prazo de Venda'),
                           controller: _prazoVendaController,
                         ),
                       ],
                     ),
                   ),
                   actions: [
                     TextButton(
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                       child: Text('Fechar'),
                     ),
                     TextButton(
                      child: Text('Adicionar'),
                      onPressed: (){
                     final String nomeProduto = _namecontroller.text;
                     final double precoVenda = double.tryParse(_precoVendaController.text) ?? 0.0;
                     final DateTime dataVenda = DateTime.tryParse(_dataVendaController.text) ?? DateTime.now();
                     final String cliente = _clienteController.text;
                     final DateTime prazoVenda = DateTime.tryParse(_prazoVendaController.text) ?? DateTime.now();
                      final venda = Vendas(
                        nome_produto: nomeProduto,
                        preco_venda: precoVenda,
                        data_venda: dataVenda,
                        cliente: cliente,
                        prazo_venda: prazoVenda,
                      );
                     Database.addVenda(venda);
                     
                     _namecontroller.clear();
                     _precoVendaController.clear();
                     _dataVendaController.clear();
                     _clienteController.clear();
                     _prazoVendaController.clear();

                      Navigator.of(context).pop();
                      setState(() {
                        _reloadKey++;
                      });
                   },
                   ),
                   ],
                 );
                });
            },
            child: const Icon(Icons.add),
           ),
    );
  }
}