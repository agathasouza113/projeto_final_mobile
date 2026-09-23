import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  Color corPrimaria = Colors.indigo;

  void mudarCor(Color novaCor) {
    setState(() {
      corPrimaria = novaCor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central de Apps',
      theme: ThemeData(
        colorSchemeSeed: corPrimaria,
        useMaterial3: true,
      ),
      home: SplashScreen(mudarCor: mudarCor),
    );
  }
}

class AppInfo {
  final String nome;
  final String descricao;
  final IconData icone;

  const AppInfo({
    required this.nome,
    required this.descricao,
    required this.icone,
  });
}

final List<AppInfo> meusApps = [
  AppInfo(
    nome: 'Calculadora de Gasolina',
    descricao: 'Calcula litros e custo de uma viagem',
    icone: Icons.local_gas_station,
  ),
  AppInfo(
    nome: 'Calculadora de Churrasco',
    descricao: 'Calcula carne, bebida e carvão',
    icone: Icons.outdoor_grill,
  ),
  AppInfo(
    nome: 'Frases Motivacionais',
    descricao: 'Mostra frases aleatórias',
    icone: Icons.auto_awesome,
  ),
  AppInfo(
    nome: 'Lista de Tarefas',
    descricao: 'Organiza suas tarefas do dia a dia',
    icone: Icons.check_circle_outline,
  ),
  AppInfo(
    nome: 'Placar de Pontos',
    descricao: 'Acompanha a pontuação de jogadores',
    icone: Icons.emoji_events,
  ),
];

class SplashScreen extends StatefulWidget {
  final void Function(Color) mudarCor;

  const SplashScreen({
    super.key,
    required this.mudarCor,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    verificarLogin();
  }

  Future<void> verificarLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final nomeSalvo = prefs.getString("nomeUsuario");

    if (!mounted) return;

    if (nomeSalvo != null && nomeSalvo.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            mudarCor: widget.mudarCor,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            mudarCor: widget.mudarCor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.apps,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Central de Apps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final void Function(Color) mudarCor;

  const LoginScreen({
    super.key,
    required this.mudarCor,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nomeController = TextEditingController();

  Future<void> entrar() async {
    if (nomeController.text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'nomeUsuario',
      nomeController.text,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          mudarCor: widget.mudarCor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apps,
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Bem-vindo(a)!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: 'Seu nome',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: entrar,
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final void Function(Color) mudarCor;

  const HomeScreen({
    super.key,
    required this.mudarCor,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nomePokemon = '';
  String? spritePokemon = '';
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarPokemon();
  }

  Future<void> buscarPokemon() async {
    final id = Random().nextInt(15);

    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/$id',
    );

    final resposta = await http.get(url);
    final dados = jsonDecode(resposta.body);

    setState(() {
      nomePokemon = dados['name'];
      spritePokemon = dados['sprites']['front_default'];
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NewWidget(
      carregando: carregando,
      spritePokemon: spritePokemon,
      nomePokemon: nomePokemon,
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.carregando,
    required this.spritePokemon,
    required this.nomePokemon,
  });

  final bool carregando;
  final String? spritePokemon;
  final String nomePokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Apps'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Central de Apps',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {},
            ),
          ],
        ),
      ),

      // CORPO DA TELA
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: carregando
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        children: [
                          if (spritePokemon != null)
                            Image.network(
                              spritePokemon!,
                              width: 56,
                              height: 56,
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pokemon do dia: '
                              '${nomePokemon[0].toUpperCase()}'
                              '${nomePokemon.substring(1)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // GRID DOS APLICATIVOS
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: meusApps.length,
              itemBuilder: (context, indice) {
                final app = meusApps[indice];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          app.icone,
                          size: 36,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          app.nome,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app.descricao,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final void Function(Color) mudarCor;

  const ProfileScreen({
    super.key,
    required this.mudarCor,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nome = '';

  final List<Color> coresDisponiveis = [
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.pink,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  Future<void> carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nome = prefs.getString('nomeUsuario') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cor do app',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}