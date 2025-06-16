import 'package:ensala_mais/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/home_page.dart';
import 'utils/project_colors.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: 'https://dvwudwlymuhkxtmynxpo.supabase.co',
    anonKey: dotenv.env['ANONKEYSUPABASE']!,
    // ANONKEYSUPABASE='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2d3Vkd2x5bXVoa3h0bXlueHBvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3MzkzMDQsImV4cCI6MjA1NzMxNTMwNH0.a5RlbNzOw_hrBkNazgcXAo6774rPpXK7gS3lKZk1Hww'
  );
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage())); //TODO lembrar de voltar
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    ProjectColors projectColors = ProjectColors();

    return Scaffold(
      backgroundColor: projectColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://unicv.edu.br/wp-content/uploads/2020/12/LOGO-BRANCO-438X166px.webp',
              scale: 1.5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.9,
              child: Card(
                color: projectColors.cardColor,
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    spacing: 8,
                    children: [
                      TextField(
                        controller: emailController,
                        cursorColor: projectColors.cursorColor,
                        decoration: InputDecoration(
                          label: Text('Email'),
                          labelStyle: TextStyle(
                            color: projectColors.cursortextColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        cursorColor: projectColors.cursorColor,
                        decoration: InputDecoration(
                          label: Text('Senha'),
                          labelStyle: TextStyle(
                            color: projectColors.cursortextColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
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
                                    email: emailController.text,
                                    password: passwordController.text);

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
                                color: projectColors.buttonTextColor,
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
                                        email: emailController.text,
                                        password: passwordController.text);

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
                                color: projectColors.buttonTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            icon: Icon(
                              Icons.login,
                              color: projectColors.buttonTextColor,
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
