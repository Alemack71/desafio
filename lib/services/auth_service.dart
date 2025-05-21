import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  //Sign in do google
  signInWithGoogle() async {
    
    //Começa o processo interativo de sign in
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //Obtem os detalhes de autenticação com o request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //Cria uma nova credencial pro usuário
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //Finalmente, vamos logar
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }
}