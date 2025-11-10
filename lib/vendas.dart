class Vendas {
  String nome_produto;
  double preco_venda;
  DateTime data_venda;
  String cliente;
  DateTime prazo_venda;
  String forma_pagamento; // Pix, Débito ou Crédito

  Vendas({
    required this.nome_produto,
    required this.preco_venda,
    required this.data_venda,
    required this.cliente,
    required this.prazo_venda,
    required this.forma_pagamento,
  });
}
