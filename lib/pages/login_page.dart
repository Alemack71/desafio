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

  //Variável para controlar CircularProgression do MyButton e SquareTile
  bool isLoading = false;
  bool isLoadingSquare = false;

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
  void signUserIn(BuildContext context) async {
    //Ativando o loading com setState
    setState(() => isLoading = true);
  
    //Tente se cadastrar
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacementNamed(context, MyRoutes.carselection);
    } on FirebaseAuthException catch (e) {
      //Mosta mensagem de erro
      showErrorMessage(e.code);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      await AuthService().signInWithGoogle();
      Navigator.pushReplacementNamed(context, MyRoutes.carselection);
    } catch (e) {
      showErrorMessage(e.toString());
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
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacementNamed(
                              context,
                              MyRoutes.resetpassword,
                            ),
                        child: Text(
                          "Esqueceu a senha?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //sign in button
                MyButton(
                  onTap: () => signUserIn(context), 
                  text: "Entrar",
                  isLoading: isLoading,
                ),

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
                        onTap: () => signInWithGoogle,
                        imagePath: 'assets/images/google.png',
                        isLoading: isLoadingSquare,
                      ),

                    if (Platform.isIOS)
                      //apple button
                      SquareTile(
                        onTap: () {},
                        imagePath: 'assets/images/apple.png',
                        isLoading: isLoadingSquare,
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
