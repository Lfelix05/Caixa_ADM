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

  // Factory constructor que calcula automaticamente o prazo_venda
  // baseado na forma de pagamento
  factory Vendas.criar({
    required String nome_produto,
    required double preco_venda,
    required DateTime data_venda,
    required String cliente,
    required String forma_pagamento,
  }) {
    DateTime prazo_venda;

    // Define o prazo_venda baseado na forma de pagamento
    switch (forma_pagamento) {
      case 'Pix':
      case 'Débito':
        // Pagamento imediato
        prazo_venda = data_venda;
        break;
      case 'Crédito':
        // Pagamento em 30 dias
        prazo_venda = data_venda.add(Duration(days: 30));
        break;
      default:
        // Caso padrão: pagamento imediato
        prazo_venda = data_venda;
    }

    return Vendas(
      nome_produto: nome_produto,
      preco_venda: preco_venda,
      data_venda: data_venda,
      cliente: cliente,
      prazo_venda: prazo_venda,
      forma_pagamento: forma_pagamento,
    );
  }
}
