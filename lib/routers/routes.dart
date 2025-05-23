import 'package:desafio/pages/auth_page.dart';
import 'package:desafio/pages/home_page.dart';
import 'package:desafio/pages/login_page.dart';
import 'package:desafio/pages/chatbot_page.dart';
import 'package:desafio/pages/register_page.dart';
import 'package:desafio/pages/reset_password.dart';
import 'package:flutter/material.dart';

class MyRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String chatbot = '/chatbot';
  static const String carselection = '/carselection';
  static const String resetpassword = '/resetpassword';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case resetpassword:
        return MaterialPageRoute(builder: (_) => ResetPassword());
      case carselection:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotPage());
      default:
        return MaterialPageRoute(builder: (_) => const AuthPage());
    }
  }
}
