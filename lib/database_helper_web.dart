import 'package:caixa/produtos.dart';
import 'package:caixa/vendas.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Armazenamento em memória para web
  static List<Map<String, dynamic>> _produtosMemory = [];
  static List<Map<String, dynamic>> _vendasMemory = [];
  static int _produtoIdCounter = 1;
  static int _vendaIdCounter = 1;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // PRODUTOS
  Future<int> insertProduto(Produto produto) async {
    final id = _produtoIdCounter++;
    _produtosMemory.add({
      'id': id,
      'nome': produto.nome,
      'preco_compra': produto.preco_compra,
      'data_entrada': produto.data_entrada.toIso8601String(),
      'fornecedor': produto.fornecedor,
      'prazo_pagar_fornecedor': produto.prazo_pagar_fornecedor
          .toIso8601String(),
    });
    return id;
  }

  Future<List<Produto>> getAllProdutos() async {
    return List.generate(_produtosMemory.length, (i) {
      return Produto(
        nome: _produtosMemory[i]['nome'],
        preco_compra: _produtosMemory[i]['preco_compra'],
        data_entrada: DateTime.parse(_produtosMemory[i]['data_entrada']),
        fornecedor: _produtosMemory[i]['fornecedor'],
        prazo_pagar_fornecedor: DateTime.parse(
          _produtosMemory[i]['prazo_pagar_fornecedor'],
        ),
      );
    });
  }

  Future<int> deleteProduto(int index) async {
    if (index < _produtosMemory.length) {
      _produtosMemory.removeAt(index);
      return 1;
    }
    return 0;
  }

  // VENDAS
  Future<int> insertVenda(Vendas venda) async {
    final id = _vendaIdCounter++;
    _vendasMemory.add({
      'id': id,
      'nome_produto': venda.nome_produto,
      'preco_venda': venda.preco_venda,
      'data_venda': venda.data_venda.toIso8601String(),
      'cliente': venda.cliente,
      'prazo_venda': venda.prazo_venda.toIso8601String(),
      'forma_pagamento': venda.forma_pagamento,
    });
    return id;
  }

  Future<List<Vendas>> getAllVendas() async {
    return List.generate(_vendasMemory.length, (i) {
      return Vendas(
        nome_produto: _vendasMemory[i]['nome_produto'],
        preco_venda: _vendasMemory[i]['preco_venda'],
        data_venda: DateTime.parse(_vendasMemory[i]['data_venda']),
        cliente: _vendasMemory[i]['cliente'],
        prazo_venda: DateTime.parse(_vendasMemory[i]['prazo_venda']),
        forma_pagamento: _vendasMemory[i]['forma_pagamento'],
      );
    });
  }

  Future<int> deleteVenda(int index) async {
    if (index < _vendasMemory.length) {
      _vendasMemory.removeAt(index);
      return 1;
    }
    return 0;
  }
}
