import 'package:ensala_mais/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://cllcycrxpolmczpzfnzr.supabase.co',
    anonKey: dotenv.env['ANONKEYSUPABASE']!,
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage())); //TODO lembrar de voltar
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFa4bc98),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://unicv.edu.br/wp-content/uploads/2020/12/logo-verde-280X100.png',
              scale: 1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.8,
              child: Card(
                color: Color(0xFFf4f6ec),
                margin: EdgeInsets.all(50),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          label: Text('Email'),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          label: Text('Senha'),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            style: ButtonStyle(),
                            onPressed: () async {
                              try {
                                await Supabase.instance.client.auth.signUp(
                                    email: _emailController.text,
                                    password: _passwordController.text);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                              } on AuthException catch (e) {
                                print(e);

                                final String errorMessage;

                                switch (e.statusCode) {
                                  case '422':
                                    errorMessage = 'Usuário já registrado!';
                                    break;
                                  case '400':
                                    errorMessage =
                                        'Email ou senha em formato inválido!';
                                  //...
                                  default:
                                    errorMessage = 'O cadastro falhou!';
                                }

                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ErrorDialog(
                                    message: errorMessage,
                                  ),
                                );
                              }
                            },
                            label: Text(
                              'Cadastrar',
                              style: TextStyle(
                                color: Color(0xFF50713c),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              try {
                                await Supabase.instance.client.auth
                                    .signInWithPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                              } on AuthException catch (e) {
                                print(e);

                                final String errorMessage;

                                switch (e.statusCode) {
                                  case '422':
                                    errorMessage = 'Usuário já registrado!';
                                    break;
                                  case '400':
                                    errorMessage =
                                        'Email ou senha em formato inválido!';
                                  //...
                                  default:
                                    errorMessage = 'O login falhou!';
                                }

                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ErrorDialog(
                                    message: errorMessage,
                                  ),
                                );
                              }
                            },
                            label: Text(
                              'Entrar',
                              style: TextStyle(
                                color: Color(0xFF50713c),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            icon: Icon(
                              Icons.login,
                              color: Color(0xFF50713c),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
