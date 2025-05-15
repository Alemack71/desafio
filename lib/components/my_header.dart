import 'package:desafio/services/weather_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
//Componentes   -----------------------------------------------
import 'package:desafio/components/navigator.dart';
//              -----------------------------------------------
import 'package:flutter/material.dart';
import '../routers/routes.dart';

class MyHeader extends StatefulWidget implements PreferredSizeWidget {
  final int selectedIndex;

  const MyHeader({super.key, required this.selectedIndex});

  @override
  State<MyHeader> createState() => _MyHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyHeaderState extends State<MyHeader> {
  @override
  void initState() {
    super.initState();

    final service = WeatherService();

    if (service.hasData) {
      temperature = service.temperature!;
      weatherDescription = service.weatherDescription!;
    } else {
      service.fetchWeather().then((_) {
        if (!mounted) return;
        setState(() {
          temperature = service.temperature!;
          weatherDescription = service.weatherDescription!;
        });
      });
    }
  }

  String temperature = "Carregando...";
  String weatherDescription = "Carregando...";

  
  //Função para deslogar usuário
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, MyRoutes.home);
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, //Define se aparece botão de voltar que é padrão do flutter quando navega para uma nova tela
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "$temperature - $weatherDescription",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: signUserOut,
          icon: Icon(Icons.logout, color: Colors.white),
        ),
        IconButton(
          onPressed: openNavigationRail,
          icon: Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }
}
