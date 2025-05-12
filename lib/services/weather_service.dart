import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  String? temperature;
  String? weatherDescription;

  bool get hasData => temperature != null && weatherDescription != null;

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

        temperature = "${data['list'][0]['main']['temp'].toStringAsFixed(1)}°C";
        weatherDescription = _translate(description);
      } else {
        temperature = "Erro ao carregar";
        weatherDescription = "Tente novamente";
      }
    } catch (_) {
      temperature = "Erro";
      weatherDescription = "Sem conexão";
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
      throw Exception(
        'Permissão negada permanentemente, vá até as configurações',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  String _translate(String desc) {
    final translations = {
      "clear sky": "Céu limpo",
      "few clouds": "Poucas nuvens",
      "scattered clouds": "Nuvens dispersas",
      "broken clouds": "Nuvens quebradas",
      "shower rain": "Chuva passageira",
      "moderate rain": "Chuva moderada",
      "light rain": "Chuva leve",
      "rain": "Chuva",
      "thunderstorm": "Trovoada",
      "snow": "Neve",
      "mist": "Névoa",
      "overcast clouds": "Nuvens nubladas",
    };
    return translations[desc] ?? desc;
  }
}
