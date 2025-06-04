import 'package:desafio/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:desafio/components/my_input.dart';
import '../routers/routes.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //Text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //Variável para controlar CircularProgression do MyButton
  bool isLoading = false;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _resetPassword() async {
    final currentContext = context;

    if (emailController.text.isEmpty) {
      showErrorMessage('Email vazio');
      return;
    }

    //Mostrando carregando
    _showDialog(currentContext);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

      if (currentContext.mounted) {
        // Fecha o loading dialog
        Navigator.pop(currentContext);
      }

      // Mostra mensagem de sucesso
      showSuccessMessage();
    } on FirebaseAuthException catch (e) {
      if (currentContext.mounted) {
        // Fecha o loading dialog
        Navigator.pop(currentContext);
      }

      showErrorMessage(e.code);
    }
  }

  void showSuccessMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: const Center(
            child: Text(
              'Verifique seu email',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            'Se o email fornecido estiver cadastrado em nosso sistema, você receberá um link para redefinir sua senha em breve.',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, MyRoutes.login);
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void showErrorMessage(String code) {
    String errorMessage;

    if (code == 'invalid-email') {
      errorMessage = 'Email inválido.';
    } else {
      errorMessage = '$code';
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
                //Logo
                const Icon(Icons.lock, size: 100),

                const SizedBox(height: 50),

                //Welcome back
                Text(
                  'Vamos redefinir sua senha!',
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
                              MyRoutes.login,
                            ),
                        child: Text(
                          "Voltar",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //Botão para enviar requisição de resetar
                MyButton(onTap: _resetPassword, text: "Enviar", isLoading: isLoading,),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
