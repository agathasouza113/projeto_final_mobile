import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedLink',
      theme: ThemeData(
        colorSchemeSeed: Color(0xFFF0F7FF),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    //Geralmente, se diz as ações da página
    super.initState();
    Future.delayed(const Duration(seconds: 4),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context){
    //O conteúdo visivel das páginas
    return Scaffold(
      backgroundColor: Color(0xFF082849),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Trocar para a Logo do proj Final
            Image.asset('assets/img/logo_principal.png'),
            SizedBox(height: 16,),
            //Trocar para o Nome e id visual do seu proj final
            Text(
              'MedLink',
              style: GoogleFonts.inter(
                color: Color(0xFFE0EFFE),
                fontSize: 24,
                fontWeight: FontWeight.bold
              )
            )
          ],
        ),
      ),
      //O conteudo vísivel da SplashScreen
      //Pode conter:
      //Uma logo centralizada
      //Um Texto com o nome do app
      //Em flutter:
      //Um center com uma Column centralizada contendo:
      //  A Imagem centralizada
      //  Uma sized box de espaçamento
      //  Um text com o nome do App
    );
  }
}

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("MedLink")),
      body: const Center(
        child: 
        Text("Em construção..."),
      ),
    );
  }
}
