import 'package:firebase_auth/firebase_auth.dart';
//Componentes   -----------------------------------------------
import 'package:desafio/components/navigator.dart';
//              -----------------------------------------------
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../pages/auth_page.dart';


class MyHeader extends StatefulWidget {
  final int selectedIndex;

  const MyHeader({super.key, required this.selectedIndex});

  @override
  State<MyHeader> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {

  String temperature = "Carregando...";
  String weatherDescription = "Carregando...";  

  //Map de traduções do clima
  final Map<String, String> weatherTranslations = {
    "clear sky": "Céu limpo",
    "few clouds": "Poucas nuvens",
    "scattered clouds": "Nuvens dispersas",
    "broken clouds": "Nuvens quebradas",
    "shower rain": "Chuva passageira",
    "moderate-rain": "Chuva moderada",
    "rain": "Chuva",
    "thunderstorm": "Trovoada",
    "snow": "Neve",
    "mist": "Névoa",
    "overcast clouds": "Nuvens nubladas",
  };

  //Função para deslogar usuário
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (route) => false,
    );
  }
  
  //Função para abrir menu bar
  void openNavigationRail() {
    showDialog(
      context: context,
      //Se clicar fora fecha
      barrierDismissible: true, 
      builder: (context) => MyNavigator(selectedIndex: widget.selectedIndex),
    );
  }

  //Método para buscar previsão do tempo
  Future<void> fetchWeather() async {
  try {
    Position position = await _determinedPosition();
    print("Localização: ${position.latitude}, ${position.longitude}");

    String weatherApiUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=e9dc3c8401ef772f695ab64982122465";

    final response = await http.get(Uri.parse(weatherApiUrl));

    print("Status Code: ${response.statusCode}");
    print("Resposta: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String description = data['list'][0]['weather'][0]['description'];

      // Traduzindo se houver uma correspondência
      String translatedDescription = weatherTranslations[description] ?? description;

      setState(() {
        temperature = "${data['list'][0]['main']['temp'].toStringAsFixed(1)}°C";
        weatherDescription = translatedDescription;
      });
    } else {
      setState(() {
        temperature = "Erro ao carregar";
        weatherDescription = "Tente novamente";
      });
    }
  } catch (e) {
    if (!mounted) return;
    
      setState(() {
        temperature = "Erro";
        weatherDescription = "Sem conexão";
      });
    }
  }

  //Método para pegar a localização do usuário
  Future<Position> _determinedPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Verifica se o serviço está ativo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desativado');
    }

    //Verifica permissão do usuário
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente, vá até as configurações');
    }

    return await Geolocator.getCurrentPosition();
  }
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "$temperature - $weatherDescription",
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
              onPressed: signUserOut, 
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: openNavigationRail,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
          ),
        ],
      );
  }
}