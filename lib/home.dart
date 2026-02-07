import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/anotacao_helper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

 _exibirTelaCadastro( {Anotacao? anotacao} ){

  String textoSalvarAtualizar = "";
  if(anotacao == null){
    _tituloController.text = "";
    _descricaoController.text = "";
    textoSalvarAtualizar = "Salvar";
  }else{
    _tituloController.text = anotacao.titulo;
    _descricaoController.text = anotacao.descricao;
    textoSalvarAtualizar = "Atualizar";
  }

  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Text("$textoSalvarAtualizar anotação"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightGreen
                  )
                ),
                labelText: "Título",
                labelStyle: TextStyle(color: Colors.black),
                hintText: "Digite o título...",
              ),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.lightGreen
                  )
                ),
                labelText: "Descrição",
                labelStyle: TextStyle(color: Colors.black),
                hintText: "Digite a descrição"
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancelar")
          ),
          TextButton(
            onPressed: (){

              //método de salvar
              _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
              Navigator.pop(context);
            }, 
            child: Text(textoSalvarAtualizar)
          )
        ],
      );
    }
  );
 
 }

 _recuperarAnotacao() async{
  List anotacoesRecuperadas = await _db.recuperarAnotacao();

  List<Anotacao>? listaTemporaria = [];

  for(var item in anotacoesRecuperadas){
    Anotacao anotacao = Anotacao.fromMap(item);
    listaTemporaria.add(anotacao);
  }

  setState(() {
    _anotacoes = listaTemporaria!;
  });

  listaTemporaria = null;
  //print("anotações recuperadas: ${anotacoesRecuperadas.toString()}");
 }

 _salvarAtualizarAnotacao( {Anotacao? anotacaoSelecionada} ) async {
  String titulo = _tituloController.text;
  String descricao = _descricaoController.text;
  
  if(anotacaoSelecionada == null){
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int result = await _db.salvarAnotacao(anotacao);
  }else{
    anotacaoSelecionada.titulo = titulo;
    anotacaoSelecionada.descricao = descricao;
    anotacaoSelecionada.data = DateTime.now().toString();
    int qtdAtualizada = await _db.atualizarNota(anotacaoSelecionada);
  }
  
  
  _tituloController.clear();
  _descricaoController.clear();

  _recuperarAnotacao();
 }

 _formatarData(String data){

  initializeDateFormatting("pt_BR");
  /* d -> dia
    M -> mês
    y -> ano
    H -> hora
    m -> minutos
    s -> segundos
  */
  var formatter = DateFormat("dd/MM/y H:m:s");
  DateTime dataConvertida = DateTime.parse(data);
  String dataFormatada = formatter.format(dataConvertida);

  return dataFormatada;

 }

 _removerAnotacao(int id) async{
  await _db.removerAnotacao(id);
  _recuperarAnotacao();
 }


  @override
  void initState() {
    super.initState();
    _recuperarAnotacao();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Minhas anotações",
          style: TextStyle(fontFamily: "Helvetica", fontSize: 25),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){

                final anotacao = _anotacoes[index];
                return Card(
                  shadowColor: Colors.black,
                  elevation: 4,
                  child: ListTile(
                    title: Text(anotacao.titulo),
                    subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(anotacao: anotacao);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.edit, color: Colors.green,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _removerAnotacao(anotacao.id!);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(Icons.remove_circle, color: Colors.red,),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                );
              },
              itemCount: _anotacoes.length,
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _exibirTelaCadastro(),
        child: Icon(Icons.add),
      ),
    );
  }
}