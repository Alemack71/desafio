import 'package:desafio/components/my_button.dart';
import 'package:desafio/components/square_tile.dart';
import 'package:desafio/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:desafio/components/my_input.dart';
import 'dart:io';
import '../routers/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool loading = false;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  //Entrar pelo firebase
  void signUserIn() async {
    //Armazenando o context em uma variável para evitar que meu context se torna inválido se o widget for desmontado durante o await
    final currentContext = context;

    //Mostrando carregando
    _showDialog(currentContext);

    //Tente se cadastrar
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      //Usando pushReplacementNamed com o context correto
      if (currentContext.mounted) {
        Navigator.pop(currentContext); // Fecha o loading
        Navigator.pushReplacementNamed(currentContext, MyRoutes.carselection);
      }
    } on FirebaseAuthException catch (e) {
      //Finaliza o circulo de carregando se o widget ainda estiver montado
      if (currentContext.mounted) {
        Navigator.pop(currentContext);
        //Mosta mensagem de erro
        showErrorMessage(e.code);
      }
    }
  }

  //Entrar pela conta google
  void _signInWithGoogle() async {
    //Armazenando o context em uma variável para evitar que meu context se torna inválido se o widget for desmontado durante o await
    final currentContext = context;

    //Mostrando carregando
    _showDialog(currentContext);

    //Tente se cadastrar
    try {
      await AuthService().signInWithGoogle();

      if (currentContext.mounted) {
        Navigator.pop(currentContext); // Fecha o loading
        Navigator.pushReplacementNamed(currentContext, MyRoutes.carselection);
      }
    } catch (e) {
      if (currentContext.mounted) {
        Navigator.pop(currentContext); //Fecha o loading
        //Mostra mensagem de erro
        showErrorMessage(e.toString());
      }
    }
  }

  //Popup de credencial incorreta
  void showErrorMessage(String code) {
    String errorMessage;

    switch (code) {
      case 'invalid-credential':
        errorMessage = 'Email ou senha incorretos.';
        break;
      default:
        errorMessage = 'Erro: $code';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                //Logo
                const Icon(Icons.lock, size: 100),

                const SizedBox(height: 50),

                //Welcome back
                Text(
                  'Bem vindo de volta, estavamos sentindo sua falta!',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 25),

                //Username input
                MyInput(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Password input
                MyInput(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //Forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(onTap: signUserIn, text: "Entrar"),

                const SizedBox(height: 50),

                //or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[400]),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ou continue com',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),

                    Expanded(
                      child: Divider(thickness: 0.5, color: Colors.grey[400]),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                //google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Platform.isAndroid)
                      // google button
                      SquareTile(
                        onTap: _signInWithGoogle,
                        imagePath: 'assets/images/google.png',
                      ),

                    if (Platform.isIOS)
                      //apple button
                      SquareTile(
                        onTap: () {},
                        imagePath: 'assets/images/apple.png',
                      ),
                  ],
                ),

                const SizedBox(height: 50),

                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não é um membro?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap:
                          () => Navigator.pushReplacementNamed(
                            context,
                            MyRoutes.register,
                          ),
                      child: const Text(
                        "Cadastre-se agora",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
