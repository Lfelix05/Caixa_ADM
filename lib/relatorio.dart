import 'database.dart';

class Relatorio {
  static double previsaoGastos = 0.0;

  // Calcula o PMRE (Prazo Médio de Renovação de Estoques)
  // Média das diferenças entre data de entrada e data de venda
  static double calcularPMRE() {
    if (Database.vendas.isEmpty || Database.produtos.isEmpty) return 0.0;

    double somaDiferencias = 0.0;
    int contagem = 0;

    for (var venda in Database.vendas) {
      // Encontra o produto correspondente pela venda
      var produto = Database.produtos.firstWhere(
        (p) => p.nome == venda.nome_produto,
        orElse: () => Database.produtos.first,
      );

      // Calcula a diferença em dias entre entrada e saída
      int diasEstoque = venda.data_venda
          .difference(produto.data_entrada)
          .inDays;
      if (diasEstoque >= 0) {
        somaDiferencias += diasEstoque;
        contagem++;
      }
    }

    return contagem > 0 ? somaDiferencias / contagem : 0.0;
  }

  // Calcula o PMRV (Prazo Médio de Recebimento de Vendas)
  // Média da diferença em dias entre prazo_venda e data_venda
  static double calcularPMRV() {
    if (Database.vendas.isEmpty) return 0.0;

    double somaPrazos = 0.0;

    for (var venda in Database.vendas) {
      // Calcula a diferença em dias entre o prazo de venda e a data da venda
      int diasPrazo = venda.prazo_venda.difference(venda.data_venda).inDays;
      somaPrazos += diasPrazo;
    }

    return somaPrazos / Database.vendas.length;
  }

  // Calcula o Ciclo Operacional (PMRE + PMRV)
  static double calcularCicloOperacional() {
    return calcularPMRE() + calcularPMRV();
  }

  // Calcula o PMPF (Prazo Médio de Pagamento a Fornecedor)
  static double calcularPMPF() {
    if (Database.produtos.isEmpty) return 0.0;

    double somaPrazos = 0.0;

    for (var produto in Database.produtos) {
      int diasPrazo = produto.prazo_pagar_fornecedor
          .difference(produto.data_entrada)
          .inDays;
      somaPrazos += diasPrazo;
    }

    return somaPrazos / Database.produtos.length;
  }

  // Calcula o Ciclo de Caixa (Ciclo Operacional - PMPF)
  static double calcularCicloCaixa() {
    return calcularCicloOperacional() - calcularPMPF();
  }

  // Calcula o Giro do Caixa (Ciclo de Caixa / 360)
  static double calcularGiroCaixa() {
    double cicloCaixa = calcularCicloCaixa();
    if (cicloCaixa == 0) return 0.0;
    return cicloCaixa / 360;
  }

  // Calcula o Saldo Mínimo de Caixa
  // (Previsão de Despesas / Giro do Caixa)
  static double calcularSaldoMinimoCaixa() {
    double giroCaixa = calcularGiroCaixa();
    if (giroCaixa == 0) return 0.0;
    return previsaoGastos / giroCaixa;
  }
}
