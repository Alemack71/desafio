import 'package:desafio/pages/home_page.dart';
import 'package:desafio/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //Usuário está logado
          if (snapshot.hasData) {
            return HomePage();
          }

          //Usuário NÃO está logado
          else {
            return LoginPage();
          }
        },
      ),    
    );
  }
}