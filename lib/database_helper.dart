import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:caixa/produtos.dart';
import 'package:caixa/vendas.dart';
import 'dart:io' show Platform;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Inicializar FFI para Windows/Linux/Mac
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'caixa.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
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
    final db = await database;
    return await db.insert('produtos', {
      'nome': produto.nome,
      'preco_compra': produto.preco_compra,
      'data_entrada': produto.data_entrada.toIso8601String(),
      'fornecedor': produto.fornecedor,
      'prazo_pagar_fornecedor': produto.prazo_pagar_fornecedor.toIso8601String(),
    });
  }

  Future<List<Produto>> getAllProdutos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produtos');

    return List.generate(maps.length, (i) {
      return Produto(
        nome: maps[i]['nome'],
        preco_compra: maps[i]['preco_compra'],
        data_entrada: DateTime.parse(maps[i]['data_entrada']),
        fornecedor: maps[i]['fornecedor'],
        prazo_pagar_fornecedor: DateTime.parse(maps[i]['prazo_pagar_fornecedor']),
      );
    });
  }

  Future<int> deleteProduto(int index) async {
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
    final db = await database;
    final vendas = await db.query('vendas');
    if (index < vendas.length) {
      final id = vendas[index]['id'] as int;
      return await db.delete('vendas', where: 'id = ?', whereArgs: [id]);
    }
    return 0;
  }
}
