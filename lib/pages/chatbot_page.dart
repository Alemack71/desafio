import 'package:firebase_auth/firebase_auth.dart';
//Componentes   -----------------------------------------------
import 'package:desafio/components/my_button.dart';
import 'package:desafio/components/navigator.dart';
//              -----------------------------------------------
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.seuapp.ia_channel');

class ChatbotPage extends StatefulWidget {
  final int selectedIndex;

  const ChatbotPage({super.key, this.selectedIndex = 1});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  //Controller para outros widgets conseguirem ler o texto escrito em TextField
  final TextEditingController _controller = TextEditingController();

  final String apiRequestUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyA5Rviqje5bNnAb1AsPcm_aird7Jp2evR8";
  String apiResponse = "";

  //Função para abrir menu bar
  void openNavigationRail() {
    showDialog(
      context: context,
      //Se clicar fora fecha
      barrierDismissible: true, 
      builder: (context) => MyNavigator(selectedIndex: selectedIndex),
    );
  }

  //Função para apagar o texto e voltar o textField ao tamanho inicial
  void _clearText() {
    setState(() {
      _controller.clear();
    });
  }

  //Método para enviar pergunta e receber resposta
  Future<void> sendQuestion() async {
    try {
      // Mostrando carregando
      showDialog(
        context: context,
        barrierDismissible: false, // impede o usuário de fechar o dialog clicando fora
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final response = await http.post(
        Uri.parse(apiRequestUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": _controller.text
                }
              ]
            }
          ]
        }),
      );

      // Fechando o carregando
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String apiResponse = jsonResponse["candidates"][0]["content"]["parts"][0]
          ["text"] ??
              "Nenhuma resposta recebida.";

        Navigator.pushNamed(
          context,
          '/ia_response',
          arguments: apiResponse,
        );
      } else {
        setState(() {
          apiResponse = "Erro ao carregar dados: ${response.statusCode}";
        });
      }
    } catch (e) {
      // garante que o carregando some mesmo em caso de erro
      Navigator.pop(context); 
      setState(() {
        apiResponse = "Erro: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300], 
      appBar: AppBar(
        automaticallyImplyLeading: false, //Define se aparece botão de voltar que é padrão do flutter quando navega para uma nova tela
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Chatbot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
            IconButton(
              onPressed: openNavigationRail,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, //Começa em cima
            children: [
              TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  labelText: 'Digite algo para o nosso chatbot!',
                  labelStyle: TextStyle(color: Colors.grey[500]),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _clearText,
                  )
                ),
              ),

              SizedBox(height: 10),

              //Botão para mandar texto 

              MyButton(
                  onTap: () {
                    if(_controller.text.isNotEmpty) {
                      sendQuestion();
                    }
                  },
                  text: "Perguntar",
                ),  
              
                
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Bem vindo ${currentUser?.email ?? ""}!"
                ),
              ),
                SingleChildScrollView(
                  child: Text(
                    apiResponse,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                    
            ],
          ),
        )
      ),
    );
  }
}