import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //IMPORT NECESSARIO PARA CONSUMIR API

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Poke API'),
        ),
        body: PokeList(),
      ),
    );
  }
}

//WIDGET COM A LOGICA PRA PESQUISAR O POKEMON NA API
class PokeList extends StatefulWidget {
  @override
  _PokeListState createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? pokemonData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //INPUT PRA COLOCAR O NOME DO POKEMON
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Nome do Pokémon',
            ),
          ),
          SizedBox(height: 16),

          //BOTÃO PARA PESQUISAR
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                searchPokemon(_controller.text.toLowerCase());
              }
            },
            child: Text('Consultar'),
          ),

          //INFORMÇÕES QUE EU ESCOLHI PRA PEGAR DA API
          SizedBox(height: 16),
          if (pokemonData != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${pokemonData!['name']}'),
                Text('ID: ${pokemonData!['id']}'),
                Text('Altura: ${pokemonData!['height']}'),
                Text('Peso: ${pokemonData!['weight']}'),
              ],
            ),
        ],
      ),
    );
}
  //FUNÇÃO QUE BUSCA O POKEMON NA API
  Future<void> searchPokemon(String pokemonName) async {
    final response =
    await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));

    //VALIDA: SE O POKEMON FOI ENCONTRADO, ENTÃO ELE ME MOSTRA AS INFOS
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemonData = {
          'name': data['name'],
          'id': data['id'],
          'height': data['height'],
          'weight': data['weight'],
        };
      });
    } else {
      //CASO ELE NÃO ENCONTRE, ELE MOSTRA UMA CAIXA DE DIALOGO INDICANDO O ERRO AO USUARIO
      setState(() {
        pokemonData = null;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erro'),
          content: Text('Não foi possível encontrar o Pokémon.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}