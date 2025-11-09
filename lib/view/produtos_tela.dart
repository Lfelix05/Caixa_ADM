import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caixa/database.dart';
import 'package:caixa/produtos.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Remove tudo que não é número
    final numbersOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    // Se apagou, permite
    if (numbersOnly.length <
        oldValue.text.replaceAll(RegExp(r'[^0-9]'), '').length) {
      return newValue;
    }

    // Limita a 8 dígitos (ddmmaaaa)
    if (numbersOnly.length > 8) {
      return oldValue;
    }

    String formatted = '';
    for (int i = 0; i < numbersOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += numbersOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  int _reloadKey = 0;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _precoCompraController = TextEditingController();
  final TextEditingController _dataEntradaController = TextEditingController();
  final TextEditingController _fornecedorController = TextEditingController();
  final TextEditingController _prazoPagamentoController =
      TextEditingController();

  DateTime? _parseDate(String dateText) {
    if (dateText.isEmpty) return null;

    // Remove qualquer caractere que não seja número
    final numbersOnly = dateText.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbersOnly.length != 8) return null;

    try {
      final day = int.parse(numbersOnly.substring(0, 2));
      final month = int.parse(numbersOnly.substring(2, 4));
      final year = int.parse(numbersOnly.substring(4, 8));

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Produtos')),
      body: Database.produtos.isEmpty
          ? const Center(
              child: Text(
                'Nenhum produto cadastrado.\nClique no botão + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: Database.produtos.length,
              itemBuilder: (context, index) {
                final produto = Database.produtos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      produto.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preço: R\$ ${produto.preco_compra.toStringAsFixed(2)}',
                        ),
                        Text('Fornecedor: ${produto.fornecedor}'),
                        Text(
                          'Data de entrada: ${produto.data_entrada.day}/${produto.data_entrada.month}/${produto.data_entrada.year}',
                        ),
                        Text(
                          'Prazo pagamento: ${produto.prazo_pagar_fornecedor.day}/${produto.prazo_pagar_fornecedor.month}/${produto.prazo_pagar_fornecedor.year}',
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          Database.produtos.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                constraints: BoxConstraints(
                  minWidth: 300,
                  maxWidth: 800,
                  minHeight: 500,
                  maxHeight: 600,
                ),
                title: const Text('Adicionar Produto'),
                content: Column(
                  children: [
                    TextField(
                      controller: _namecontroller,
                      decoration: const InputDecoration(
                        labelText: 'Nome do produto',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _precoCompraController,
                      decoration: const InputDecoration(
                        labelText: 'Preço de compra',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _dataEntradaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Data de entrada',
                        hintText: 'dd/mm/aaaa',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _fornecedorController,
                      decoration: const InputDecoration(
                        labelText: 'Fornecedor',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _prazoPagamentoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [DateInputFormatter()],
                      decoration: const InputDecoration(
                        labelText: 'Prazo para pagar fornecedor',
                        hintText: 'dd/mm/aaaa',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      final String nome = _namecontroller.text;
                      final double precoCompra =
                          double.tryParse(_precoCompraController.text) ?? 0.0;
                      final DateTime dataEntrada =
                          _parseDate(_dataEntradaController.text) ??
                          DateTime.now();
                      final String fornecedor = _fornecedorController.text;
                      final DateTime prazoPagamento =
                          _parseDate(_prazoPagamentoController.text) ??
                          DateTime.now();

                      Database.addProduto(
                        Produto(
                          nome: nome,
                          preco_compra: precoCompra,
                          data_entrada: dataEntrada,
                          fornecedor: fornecedor,
                          prazo_pagar_fornecedor: prazoPagamento,
                        ),
                      );

                      _namecontroller.clear();
                      _precoCompraController.clear();
                      _dataEntradaController.clear();
                      _fornecedorController.clear();
                      _prazoPagamentoController.clear();

                      Navigator.of(context).pop();
                      setState(() {
                        _reloadKey++;
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
