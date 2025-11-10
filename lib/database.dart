import 'produtos.dart';
import 'vendas.dart';

class Database {
  static List<Produto> produtos = [];

  static List<Vendas> vendas = [];

  static void addProduto(Produto produto) {
    final Produto newProduto = Produto(
      nome: produto.nome,
      preco_compra: produto.preco_compra,
      data_entrada: produto.data_entrada,
      fornecedor: produto.fornecedor,
      prazo_pagar_fornecedor: produto.prazo_pagar_fornecedor,
    );
    produtos.add(newProduto);
  }

  static void addVenda(Vendas venda) {
    final Vendas newVenda = Vendas(
      nome_produto: venda.nome_produto,
      preco_venda: venda.preco_venda,
      data_venda: venda.data_venda,
      cliente: venda.cliente,
      prazo_venda: venda.prazo_venda,
      forma_pagamento: venda.forma_pagamento,
    );
    vendas.add(newVenda);
  }
}
