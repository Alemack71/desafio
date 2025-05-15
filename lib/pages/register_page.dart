import 'package:desafio/components/my_button.dart';
import 'package:desafio/components/square_tile.dart';
import 'package:desafio/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:desafio/components/my_input.dart';
import 'dart:io';
import '../routers/routes.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  //Sign user up method
  void signUserUp() async {
    //Armazenando o context em uma variável para evitar que meu context se torna inválido se o widget for desmontado durante o await
    final currentContext = context;

    //Mostrando carregando
    _showDialog(currentContext);
    
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(currentContext);
      //Mostra mensagem de erro, senha não bate
      showErrorMessage("Senhas não estão iguais");
      return;
    }

    //Tente criar o usuário
    try {
      //Checa se a senha está confirmada
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
      } 
      if (currentContext.mounted) {
        Navigator.pop(currentContext); // Fecha o loading
        Navigator.pushReplacementNamed(currentContext, MyRoutes.carselection);
      }
    } on FirebaseAuthException catch (e) {
      if (currentContext.mounted) {
        //Finaliza o circulo de carregando
        Navigator.pop(currentContext);
        //Mosta mensagem de erro
        showErrorMessage(e.code);
      }
    }
  }

  //Popup de credencial incorreta
  void showErrorMessage(String message) {

    //Traduzindo mensagem de email em uso
    if (message == 'email-already-in-use') {
      message = "email já em uso.";
    }

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
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
        child:Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
            
                //Logo
                const Icon(
                  Icons.lock,
                  size: 65,
                ),
            
                const SizedBox(height: 50),
            
                //Welcome back
                Text(
                  'Vamos criar uma conta para você!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //Campo de usuário
                MyInput(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                //Campo de senha  
                MyInput(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //Confirmar senha
                MyInput(
                  controller: confirmPasswordController,
                  hintText: "Confirmar senha",
                  obscureText: true,
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  onTap: signUserUp,
                  text: "Registre-se",
                ),
            
                const SizedBox(height: 50),
            
                //or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
            
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Ou continue com',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      
                    ),
            
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
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
                        onTap: () => AuthService().signInWithGoogle(),
                        imagePath: 'assets/images/google.png'
                      ),

                    if (Platform.isIOS)
                      //apple button
                      SquareTile(
                        onTap: () {},
                        imagePath: 'assets/images/apple.png'
                      ),
                  ],
                ),
            
                const SizedBox(height: 50),
            
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Cadastre-se agora",
                        style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}