# Sistema de Informações Gerenciais - Caixa ADM

> ⚠️ **Projeto Acadêmico** - Este é um projeto desenvolvido exclusivamente para fins educacionais como parte de um trabalho acadêmico.

## 📋 Sobre o Projeto

Sistema de gestão desenvolvido em Flutter para controle de produtos, vendas e análise de indicadores gerenciais. O aplicativo permite o cadastro de produtos e vendas, além de calcular automaticamente indicadores financeiros importantes para a gestão de caixa.

**Desenvolvido como trabalho acadêmico para a disciplina de Sistema de Informações Gerenciais.**

## 🎯 Funcionalidades

### 📦 Gestão de Produtos
- Cadastro de produtos com informações completas
- Registro de preço de compra, data de entrada e fornecedor
- Definição de prazo de pagamento ao fornecedor
- Visualização organizada dos produtos cadastrados
- Exclusão de produtos

### 💰 Gestão de Vendas
- Registro de vendas vinculadas aos produtos cadastrados
- Seleção de forma de pagamento (Pix, Débito ou Crédito)
- Definição de preço de venda e cliente
- Registro de data da venda e prazo de recebimento
- Histórico completo de vendas

### 📊 Relatório de Gestão
O sistema calcula automaticamente os seguintes indicadores:

#### Indicadores Calculados:
- **PMRE** (Prazo Médio de Renovação de Estoques)
  - Calcula a média de dias entre entrada e saída de produtos
  
- **PMRV** (Prazo Médio de Recebimento de Vendas)
  - Baseado na forma de pagamento:
    - Pix: 0 dias
    - Débito: 0 dias
    - Crédito: 30 dias
  
- **Ciclo Operacional**
  - Fórmula: PMRE + PMRV
  
- **PMPF** (Prazo Médio de Pagamento a Fornecedor)
  - Média dos prazos de pagamento aos fornecedores
  
- **Ciclo de Caixa**
  - Fórmula: Ciclo Operacional - PMPF
  
- **Giro do Caixa**
  - Fórmula: Ciclo de Caixa / 360
  
- **Saldo Mínimo de Estoque**
  - Fórmula: Previsão de Despesas / Giro do Caixa

#### Configurações:
- Definição de previsão de gastos do período
- Visualização detalhada de todos os cálculos

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Dart** - Linguagem de programação
- **Material Design** - Interface do usuário

## 📱 Estrutura do Projeto

```
lib/
├── database.dart              # Gerenciamento de dados em memória
├── date_input_formatter.dart  # Formatador de datas (dd/mm/aaaa)
├── main.dart                  # Ponto de entrada do aplicativo
├── produtos.dart              # Modelo de dados - Produto
├── vendas.dart                # Modelo de dados - Venda
├── relatorio.dart             # Cálculos dos indicadores gerenciais
└── view/
    ├── home.dart              # Tela inicial
    ├── produtos_tela.dart     # Tela de gestão de produtos
    ├── vendas_tela.dart       # Tela de gestão de vendas
    └── relatorio_tela.dart    # Tela de relatórios gerenciais
```

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK instalado
- Editor de código (VS Code, Android Studio, etc.)
- Emulador ou dispositivo físico para testes

### Passos para execução

1. Clone o repositório:
```bash
git clone https://github.com/Lfelix05/Caixa_ADM.git
cd Caixa_ADM
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

## 💡 Como Usar

1. **Cadastrar Produtos**
   - Acesse "Produtos" na tela inicial
   - Clique no botão "+"
   - Preencha os dados: nome, preço de compra, data de entrada, fornecedor e prazo de pagamento

2. **Registrar Vendas**
   - Acesse "Vendas" na tela inicial
   - Clique no botão "+"
   - Selecione o produto, defina preço, forma de pagamento, cliente e prazos

3. **Visualizar Relatórios**
   - Acesse "Relatório" na tela inicial
   - Defina a previsão de gastos do período
   - Visualize todos os indicadores calculados automaticamente

## 📝 Observações Importantes

- **Armazenamento Temporário**: Os dados são armazenados apenas na memória do aplicativo e serão perdidos ao fechar o app
- **Projeto Acadêmico**: Este sistema foi desenvolvido para fins educacionais e demonstração de conceitos de gestão financeira
- **Validações**: Todos os campos possuem validações para garantir a integridade dos dados

## 👨‍💻 Autor

Desenvolvido por Lucas Felix como trabalho acadêmico.

## 📄 Licença

Este projeto é apenas para fins acadêmicos e educacionais.

---

**Nota**: Este é um projeto acadêmico e não deve ser utilizado em ambiente de produção sem as devidas adaptações de segurança, persistência de dados e otimizações necessárias.
