import 'package:flutter/material.dart';
import 'package:caixa/database.dart';
import 'package:caixa/date_input_formatter.dart';
import '../vendas.dart';

class VendasPage extends StatefulWidget {
  const VendasPage({super.key});

  @override
  State<VendasPage> createState() => _VendasPageState();
}

class _VendasPageState extends State<VendasPage> {
  int _reloadKey = 0;
  String? _produtoSelecionado;
  String? _formaPagamentoSelecionada;
  final TextEditingController _precoVendaController = TextEditingController();
  final TextEditingController _dataVendaController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _prazoVendaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendas'), elevation: 0),
      body: Database.vendas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma venda registrada',
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
              itemCount: Database.vendas.length,
              itemBuilder: (context, index) {
                final venda = Database.vendas[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.green, width: 5),
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
                                  venda.nome_produto,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                'R\$ ${venda.preco_venda.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          _buildInfoRow(
                            Icons.person_outline,
                            'Cliente',
                            venda.cliente,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.payment,
                            'Forma de Pagamento',
                            venda.forma_pagamento,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Data da Venda',
                            '${venda.data_venda.day.toString().padLeft(2, '0')}/${venda.data_venda.month.toString().padLeft(2, '0')}/${venda.data_venda.year}',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.event_available,
                            'Prazo de Venda',
                            '${venda.prazo_venda.day.toString().padLeft(2, '0')}/${venda.prazo_venda.month.toString().padLeft(2, '0')}/${venda.prazo_venda.year}',
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
                  'Adicionar Venda',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Produto',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          initialValue: _produtoSelecionado,
                          items: Database.produtos.isEmpty
                              ? null
                              : Database.produtos.map((produto) {
                                  return DropdownMenuItem<String>(
                                    value: produto.nome,
                                    child: Text(produto.nome),
                                  );
                                }).toList(),
                          onChanged: Database.produtos.isEmpty
                              ? null
                              : (String? newValue) {
                                  setState(() {
                                    _produtoSelecionado = newValue;
                                  });
                                },
                          hint: Text(
                            Database.produtos.isEmpty
                                ? 'Nenhum produto'
                                : 'Selecione um produto',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Preço de Venda',
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ ',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                          controller: _precoVendaController,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Forma de Pagamento',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.payment),
                          ),
                          initialValue: _formaPagamentoSelecionada,
                          items: ['Pix', 'Débito', 'Crédito'].map((forma) {
                            return DropdownMenuItem<String>(
                              value: forma,
                              child: Text(forma),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _formaPagamentoSelecionada = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Data da Venda',
                            hintText: 'dd/mm/aaaa',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          controller: _dataVendaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [DateInputFormatter()],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Cliente',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          controller: _clienteController,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Prazo de Venda',
                            hintText: 'dd/mm/aaaa',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.event_available),
                          ),
                          controller: _prazoVendaController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [DateInputFormatter()],
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
                      if (_produtoSelecionado == null ||
                          _produtoSelecionado!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, selecione um produto'),
                          ),
                        );
                        return;
                      }

                      if (_precoVendaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, insira o preço de venda'),
                          ),
                        );
                        return;
                      }

                      if (_formaPagamentoSelecionada == null ||
                          _formaPagamentoSelecionada!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Por favor, selecione a forma de pagamento',
                            ),
                          ),
                        );
                        return;
                      }

                      final double? precoVenda = double.tryParse(
                        _precoVendaController.text,
                      );
                      if (precoVenda == null || precoVenda <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, insira um preço válido'),
                          ),
                        );
                        return;
                      }

                      final DateTime dataVenda;
                      if (_dataVendaController.text.isEmpty) {
                        dataVenda = DateTime.now();
                      } else {
                        final DateTime? parsedDate = parseDate(
                          _dataVendaController.text,
                        );
                        if (parsedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor, insira uma data válida (dd/mm/aaaa)',
                              ),
                            ),
                          );
                          return;
                        }
                        dataVenda = parsedDate;
                      }

                      if (_clienteController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Por favor, insira o nome do cliente',
                            ),
                          ),
                        );
                        return;
                      }

                      final DateTime? prazoVenda;
                      if (_prazoVendaController.text.isEmpty) {
                        prazoVenda = DateTime.now();
                      } else {
                        prazoVenda = parseDate(
                          _prazoVendaController.text,
                        );
                        return;
                      }

                      final String nomeProduto = _produtoSelecionado!;
                      final String cliente = _clienteController.text;
                      final String formaPagamento = _formaPagamentoSelecionada!;

                      final venda = Vendas(
                        nome_produto: nomeProduto,
                        preco_venda: precoVenda,
                        data_venda: dataVenda,
                        cliente: cliente,
                        prazo_venda: prazoVenda,
                        forma_pagamento: formaPagamento,
                      );
                      Database.addVenda(venda);

                      _produtoSelecionado = null;
                      _formaPagamentoSelecionada = null;
                      _precoVendaController.clear();
                      _dataVendaController.clear();
                      _clienteController.clear();
                      _prazoVendaController.clear();

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
