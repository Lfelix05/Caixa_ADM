import 'database.dart'; // Assuma que 'database.dart' contém as classes Produto, Venda e Database

class Relatorio {
  // Variável para armazenar a previsão de gastos (despesas anuais)
  static double previsaoGastos = 0.0;

  // Função auxiliar para mapear a forma de pagamento ao prazo em dias
  static int _obterPrazoVendaEmDays(String formaPagamento) {
    switch (formaPagamento.toLowerCase()) {
      case 'pix':
      case 'débito':
        return 0; // Pix: 0 dias[cite: 27]; Débito: 0 dia [cite: 28]
      case 'crédito':
        return 30; // Crédito: 30 dias [cite: 29]
      default:
        // Se a forma de pagamento não for reconhecida, considera 0.
        return 0;
    }
  }

  // Calcula o PMRE (Prazo Médio de Renovação de Estoques)
  // Média das diferenças de tempo entre a data de entrada e de saída (venda)
  static double calcularPMRE() {
    if (Database.vendas.isEmpty || Database.produtos.isEmpty) return 0.0;

    double somaDiferencias = 0.0;
    int contagem = 0;

    for (var venda in Database.vendas) {
      try {
        var produto = Database.produtos.firstWhere(
          (p) => p.nome == venda.nome_produto,
        );

        // Calcula a diferença em dias entre a entrada e a venda (saída)
        int diasEstoque = venda.data_venda
            .difference(produto.data_entrada)
            .inDays;

        if (diasEstoque >= 0) {
          somaDiferencias += diasEstoque;
          contagem++;
        }
      } catch (e) {
        // Produto não encontrado, pula para a próxima venda
        continue;
      }
    }

    return contagem > 0 ? somaDiferencias / contagem : 0.0;
  }

  // Calcula o PMRV (Prazo Médio de Recebimento de Vendas)
  // Média entre formas de pagamento (dias) [cite: 26]
  static double calcularPMRV() {
    if (Database.vendas.isEmpty) return 0.0;

    double somaPrazos = 0.0;

    for (var venda in Database.vendas) {
      // Usa a função auxiliar para obter o prazo em dias, conforme as regras do trabalho
      somaPrazos += _obterPrazoVendaEmDays(venda.forma_pagamento);
    }

    return somaPrazos / Database.vendas.length;
  }

  // Calcula o PMPF (Prazo Médio de Pagamento a Fornecedor)
  // Média entre prazo de pagamento do fornecedor [cite: 32]
  static double calcularPMPF() {
    if (Database.produtos.isEmpty) return 0.0;

    double somaPrazos = 0.0;

    for (var produto in Database.produtos) {
      // Calcula a diferença em dias entre a data de entrada e a data final de pagamento
      int diasPrazo = produto.prazo_pagar_fornecedor
          .difference(produto.data_entrada)
          .inDays;
      somaPrazos += diasPrazo;
    }

    return somaPrazos / Database.produtos.length;
  }

  // Calcula o Ciclo Operacional (PMRE + PMRV) [cite: 24]
  static double calcularCicloOperacional() {
    return calcularPMRE() + calcularPMRV();
  }

  // Calcula o Ciclo de Caixa (Ciclo Operacional - PMPF) [cite: 30]
  static double calcularCicloCaixa() {
    return calcularCicloOperacional() - calcularPMPF();
  }

  // Calcula o Giro do Caixa (Ciclo de Caixa / 360) [cite: 41]
  static double calcularGiroCaixa() {
    double cicloCaixa = calcularCicloCaixa();
    // 360 é o número de dias no ano comercial usado para o cálculo.
    return cicloCaixa / 360.0;
  }

  // Calcula o Saldo Mínimo de Caixa (Previsão de Despesas / Giro do Caixa) [cite: 40]
  static double calcularSaldoMinimoCaixa() {
    double giroCaixa = calcularGiroCaixa();

    // Se o giro for zero (ou muito próximo) ou a previsão de gastos for zero, retorna 0.0
    if (giroCaixa == 0.0 || previsaoGastos == 0.0) return 0.0;

    // É comum usar o valor absoluto do Giro do Caixa no cálculo do Saldo Mínimo de Caixa
    // para indicar a necessidade de caixa, mesmo que o ciclo seja negativo.
    // O Saldo Mínimo de Caixa é a Previsão de Despesas / Giro do Caixa [cite: 40, 42]
    return previsaoGastos / giroCaixa.abs();
  }
}
