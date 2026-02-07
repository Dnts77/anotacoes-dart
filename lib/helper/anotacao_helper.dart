import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;
  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }
  
  AnotacaoHelper._internal();

  Future<Database> get db async{
    if(_db != null){
      return _db!;
    }
    else{
      _db = await startDB();
      return _db!;
    }
  }

  Future<void> _onCreate(Database db, version) async{
    String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
    await db.execute(sql);
  }

  Future<Database> startDB() async{
    final dbPath = await getDatabasesPath();
    final dbPlace = join(dbPath, "banco_minhas_anotacoes.db");

    var db = await openDatabase(dbPlace, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{
    var bancoDados = await db;
    
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap() as Map<String, Object?>);
    return resultado;

  }

  recuperarAnotacao() async{
    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await bancoDados.rawQuery( sql );
    return anotacoes;
  }

  Future<int> atualizarNota(Anotacao anotacao) async{
    var bancoDados = await db;
    return await bancoDados.update(nomeTabela, anotacao.toMap() as Map<String, Object?>, where: "id = ?", whereArgs: [anotacao.id]);
  }

  Future<int> removerAnotacao(int id) async{
    var bancoDados = await db;
    return await bancoDados.delete(nomeTabela, where: "id = ?", whereArgs: [id]);
  }

}