import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:caixa/produtos.dart';
import 'package:caixa/vendas.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Armazenamento em memória para web
  static List<Map<String, dynamic>> _produtosMemory = [];
  static List<Map<String, dynamic>> _vendasMemory = [];
  static int _produtoIdCounter = 1;
  static int _vendaIdCounter = 1;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    // Se for web, não usar banco de dados real
    if (kIsWeb) {
      throw UnsupportedError('Database não suportado na web');
    }

    if (_database != null) return _database!;

    // Inicializar FFI para desktop (Windows/Linux/Mac)
    // Para desktop sempre usamos FFI
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'caixa.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Criar tabela de produtos
    await db.execute('''
      CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        preco_compra REAL NOT NULL,
        data_entrada TEXT NOT NULL,
        fornecedor TEXT NOT NULL,
        prazo_pagar_fornecedor TEXT NOT NULL
      )
    ''');

    // Criar tabela de vendas
    await db.execute('''
      CREATE TABLE vendas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_produto TEXT NOT NULL,
        preco_venda REAL NOT NULL,
        data_venda TEXT NOT NULL,
        cliente TEXT NOT NULL,
        prazo_venda TEXT NOT NULL,
        forma_pagamento TEXT NOT NULL
      )
    ''');
  }

  // PRODUTOS
  Future<int> insertProduto(Produto produto) async {
    if (kIsWeb) {
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

    final db = await database;
    return await db.insert('produtos', {
      'nome': produto.nome,
      'preco_compra': produto.preco_compra,
      'data_entrada': produto.data_entrada.toIso8601String(),
      'fornecedor': produto.fornecedor,
      'prazo_pagar_fornecedor': produto.prazo_pagar_fornecedor
          .toIso8601String(),
    });
  }

  Future<List<Produto>> getAllProdutos() async {
    if (kIsWeb) {
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

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto(
        nome: maps[i]['nome'],
        preco_compra: maps[i]['preco_compra'],
        data_entrada: DateTime.parse(maps[i]['data_entrada']),
        fornecedor: maps[i]['fornecedor'],
        prazo_pagar_fornecedor: DateTime.parse(
          maps[i]['prazo_pagar_fornecedor'],
        ),
      );
    });
  }

  Future<int> deleteProduto(int index) async {
    if (kIsWeb) {
      if (index < _produtosMemory.length) {
        _produtosMemory.removeAt(index);
        return 1;
      }
      return 0;
    }

    final db = await database;
    final produtos = await db.query('produtos');
    if (index < produtos.length) {
      final id = produtos[index]['id'] as int;
      return await db.delete('produtos', where: 'id = ?', whereArgs: [id]);
    }
    return 0;
  }

  // VENDAS
  Future<int> insertVenda(Vendas venda) async {
    if (kIsWeb) {
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

    final db = await database;
    return await db.insert('vendas', {
      'nome_produto': venda.nome_produto,
      'preco_venda': venda.preco_venda,
      'data_venda': venda.data_venda.toIso8601String(),
      'cliente': venda.cliente,
      'prazo_venda': venda.prazo_venda.toIso8601String(),
      'forma_pagamento': venda.forma_pagamento,
    });
  }

  Future<List<Vendas>> getAllVendas() async {
    if (kIsWeb) {
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

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vendas');

    return List.generate(maps.length, (i) {
      return Vendas(
        nome_produto: maps[i]['nome_produto'],
        preco_venda: maps[i]['preco_venda'],
        data_venda: DateTime.parse(maps[i]['data_venda']),
        cliente: maps[i]['cliente'],
        prazo_venda: DateTime.parse(maps[i]['prazo_venda']),
        forma_pagamento: maps[i]['forma_pagamento'],
      );
    });
  }

  Future<int> deleteVenda(int index) async {
    if (kIsWeb) {
      if (index < _vendasMemory.length) {
        _vendasMemory.removeAt(index);
        return 1;
      }
      return 0;
    }

    final db = await database;
    final vendas = await db.query('vendas');
    if (index < vendas.length) {
      final id = vendas[index]['id'] as int;
      return await db.delete('vendas', where: 'id = ?', whereArgs: [id]);
    }
    return 0;
  }
}
