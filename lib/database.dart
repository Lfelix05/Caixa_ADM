import 'produtos.dart';
import 'vendas.dart';
import 'database_helper_web.dart' if (dart.library.io) 'database_helper.dart';

class Database {
  static List<Produto> produtos = [];
  static List<Vendas> vendas = [];
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  // Carregar dados do banco de dados
  static Future<void> loadData() async {
    produtos = await _dbHelper.getAllProdutos();
    vendas = await _dbHelper.getAllVendas();
  }

  static Future<void> addProduto(Produto produto) async {
    final Produto newProduto = Produto(
      nome: produto.nome,
      preco_compra: produto.preco_compra,
      data_entrada: produto.data_entrada,
      fornecedor: produto.fornecedor,
      prazo_pagar_fornecedor: produto.prazo_pagar_fornecedor,
    );
    produtos.add(newProduto);
    await _dbHelper.insertProduto(newProduto);
  }

  static Future<void> removeProduto(int index) async {
    await _dbHelper.deleteProduto(index);
    produtos.removeAt(index);
  }

  static Future<void> addVenda(Vendas venda) async {
    final Vendas newVenda = Vendas(
      nome_produto: venda.nome_produto,
      preco_venda: venda.preco_venda,
      data_venda: venda.data_venda,
      cliente: venda.cliente,
      prazo_venda: venda.prazo_venda,
      forma_pagamento: venda.forma_pagamento,
    );
    vendas.add(newVenda);
    await _dbHelper.insertVenda(newVenda);
  }

  static Future<void> removeVenda(int index) async {
    await _dbHelper.deleteVenda(index);
    vendas.removeAt(index);
  }
}
