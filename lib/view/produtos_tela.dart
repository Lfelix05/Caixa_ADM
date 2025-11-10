import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:caixa/database.dart';
import 'package:caixa/produtos.dart';
import 'package:caixa/date_input_formatter.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos'), elevation: 0),
      body: Database.produtos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum produto cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clique no botão + para adicionar',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: Database.produtos.length,
              itemBuilder: (context, index) {
                final produto = Database.produtos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.blue, width: 5),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  produto.nome,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    Database.produtos.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'R\$ ${produto.preco_compra.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.business,
                            'Fornecedor',
                            produto.fornecedor,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Data de Entrada',
                            '${produto.data_entrada.day.toString().padLeft(2, '0')}/${produto.data_entrada.month.toString().padLeft(2, '0')}/${produto.data_entrada.year}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.event_available,
                            'Prazo Pagamento',
                            '${produto.prazo_pagar_fornecedor.day.toString().padLeft(2, '0')}/${produto.prazo_pagar_fornecedor.month.toString().padLeft(2, '0')}/${produto.prazo_pagar_fornecedor.year}',
                          ),
                        ],
                      ),
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
                contentPadding: const EdgeInsets.all(20),
                title: const Text(
                  'Adicionar Produto',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _namecontroller,
                        decoration: const InputDecoration(
                          labelText: 'Nome do produto',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.shopping_bag_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _precoCompraController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Preço de compra',
                          border: OutlineInputBorder(),
                          prefixText: 'R\$ ',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dataEntradaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [DateInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Data de entrada',
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _fornecedorController,
                        decoration: const InputDecoration(
                          labelText: 'Fornecedor',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _prazoPagamentoController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [DateInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Prazo para pagar fornecedor',
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event_available),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_namecontroller.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, insira o nome do produto',
                            ),
                          ),
                        );
                        return;
                      }

                      if (_precoCompraController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, insira o preço de compra',
                            ),
                          ),
                        );
                        return;
                      }

                      final double? precoCompra = double.tryParse(
                        _precoCompraController.text,
                      );
                      if (precoCompra == null || precoCompra <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, insira um preço válido'),
                          ),
                        );
                        return;
                      }

                      final DateTime dataEntrada;
                      if (_dataEntradaController.text.isEmpty) {
                        dataEntrada = DateTime.now();
                      } else {
                        final DateTime? parsedDate = parseDate(
                          _dataEntradaController.text,
                        );
                        if (parsedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, insira uma data válida (dd/mm/aaaa)',
                              ),
                            ),
                          );
                          return;
                        }
                        dataEntrada = parsedDate;
                      }

                      if (_fornecedorController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, insira o fornecedor'),
                          ),
                        );
                        return;
                      }

                      final DateTime prazoPagamento;
                      if (_prazoPagamentoController.text.isEmpty) {
                        prazoPagamento = DateTime.now();
                      } else {
                        final DateTime? parsedDate = parseDate(
                          _prazoPagamentoController.text,
                        );
                        if (parsedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, insira um prazo válido (dd/mm/aaaa)',
                              ),
                            ),
                          );
                          return;
                        }
                        prazoPagamento = parsedDate;
                      }

                      final String nome = _namecontroller.text;
                      final String fornecedor = _fornecedorController.text;

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
                    child: const Text('Adicionar'),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
