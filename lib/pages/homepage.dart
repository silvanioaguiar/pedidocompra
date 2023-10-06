import 'package:flutter/material.dart';
import 'package:pedidocompra/pages/authPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // if (isLoading == true) {
    //   _loadPedidos();
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Biosat",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
            )),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fundoTelaPrincipalBiosat3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 250,
                height: 100,
                child: Image.asset('assets/images/logo_Biosat.png'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const AuthPage();
                    }),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                  foregroundColor: MaterialStateProperty.all(
                      Theme.of(context).secondaryHeaderColor),
                ),
                child: const Text('Iniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
