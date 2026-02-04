import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/helper/anotacao_helper.dart';
import 'package:minhas_anotacoes/model/anotacao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();

 _exibirTelaCadastro(){
 
  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        title: Text("Adicionar anotação"),
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
              _salvarAnotacao();
              Navigator.pop(context);
            }, 
            child: Text("Salvar")
          )
        ],
      );
    }
  );
 
 }

 _salvarAnotacao() async {
  String titulo = _tituloController.text;
  String descricao = _descricaoController.text;
  
  //print("data atual: " + DateTime.now().toString());
  Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
  int result = await _db.salvarAnotacao(anotacao);
  print("salvar anotacao: ${result.toString()}");
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
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _exibirTelaCadastro(),
        child: Icon(Icons.add),
      ),
    );
  }
}