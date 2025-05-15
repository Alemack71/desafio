import 'package:desafio/pages/auth_page.dart';
import 'package:desafio/pages/home_page.dart';
import 'package:desafio/pages/login_page.dart';
import 'package:desafio/pages/chatbot_page.dart';
import 'package:desafio/pages/register_page.dart';
import 'package:flutter/material.dart';

class MyRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String chatbot = '/chatbot';
  static const String carselection = '/carselection';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case login:
        var args = settings.arguments as Map<String, dynamic>;
        var onTap = args["onTap"];
        return MaterialPageRoute(builder: (_) => LoginPage(onTap: onTap));
      case register:
        var args = settings.arguments as Map<String, dynamic>;
        var onTap = args["onTap"];
        return MaterialPageRoute(builder: (_) => RegisterPage(onTap: onTap));
      case carselection:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotPage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
