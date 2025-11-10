import 'package:flutter/material.dart';
import 'package:caixa/relatorio.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  final TextEditingController _previsaoGastosController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _previsaoGastosController.text = Relatorio.previsaoGastos.toString();
  }

  @override
  void dispose() {
    _previsaoGastosController.dispose();
    super.dispose();
  }

  void _atualizarPrevisaoGastos() {
    final double? valor = double.tryParse(_previsaoGastosController.text);
    if (valor != null && valor >= 0) {
      setState(() {
        Relatorio.previsaoGastos = valor;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Previsão de gastos atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um valor válido'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cicloOperacional = Relatorio.calcularCicloOperacional();
    final cicloCaixa = Relatorio.calcularCicloCaixa();
    final saldoMinimo = Relatorio.calcularSaldoMinimoCaixa();
    final pmre = Relatorio.calcularPMRE();
    final pmrv = Relatorio.calcularPMRV();
    final pmpf = Relatorio.calcularPMPF();
    final giroCaixa = Relatorio.calcularGiroCaixa();

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório de Gestão')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Previsão de Gastos
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Previsão de Gastos do Período',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _previsaoGastosController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Valor em R\$',
                              border: OutlineInputBorder(),
                              prefixText: 'R\$ ',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _atualizarPrevisaoGastos,
                          child: const Text('Atualizar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Indicadores Principais
            const Text(
              'Indicadores de Gestão',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Ciclo Operacional
            _buildIndicadorCard(
              titulo: 'Ciclo Operacional',
              valor: '${cicloOperacional.toStringAsFixed(2)} dias',
              descricao: 'PMRE + PMRV',
              cor: Colors.blue,
              icone: Icons.sync,
            ),
            const SizedBox(height: 12),

            // Ciclo de Caixa
            _buildIndicadorCard(
              titulo: 'Ciclo de Caixa',
              valor: '${cicloCaixa.toStringAsFixed(2)} dias',
              descricao: 'Ciclo Operacional - PMPF',
              cor: Colors.green,
              icone: Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),

            // Saldo Mínimo de Caixa
            _buildIndicadorCard(
              titulo: 'Saldo Mínimo de Estoque',
              valor: 'R\$ ${saldoMinimo.toStringAsFixed(2)}',
              descricao: 'Previsão de Despesas / Giro do Caixa',
              cor: Colors.orange,
              icone: Icons.inventory,
            ),
            const SizedBox(height: 24),

            // Detalhes dos Cálculos
            const Text(
              'Detalhes dos Cálculos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetalheItem(
                      'PMRE (Prazo Médio Renovação Estoques)',
                      '${pmre.toStringAsFixed(2)} dias',
                    ),
                    const Divider(),
                    _buildDetalheItem(
                      'PMRV (Prazo Médio Recebimento Vendas)',
                      '${pmrv.toStringAsFixed(2)} dias',
                    ),
                    const Divider(),
                    _buildDetalheItem(
                      'PMPF (Prazo Médio Pagamento Fornecedor)',
                      '${pmpf.toStringAsFixed(2)} dias',
                    ),
                    const Divider(),
                    _buildDetalheItem(
                      'Giro do Caixa',
                      giroCaixa.toStringAsFixed(4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Informações sobre formas de pagamento
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Prazos de Recebimento',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Pix: 0 dias'),
                    const Text('• Débito: 0 dias'),
                    const Text('• Crédito: 30 dias'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicadorCard({
    required String titulo,
    required String valor,
    required String descricao,
    required Color cor,
    required IconData icone,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: cor, width: 5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icone, size: 48, color: cor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      valor,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descricao,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetalheItem(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(
            valor,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
