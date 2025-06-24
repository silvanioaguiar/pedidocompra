import 'package:flutter/material.dart';
import 'package:pedidocompra/main.dart';
import '../components/authForm.dart';
import '../models/authFormData.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  void _handleSubmit(AuthFormData formData) {
    setState(() => _isLoading = true);

    print('AuthPage...');
    print(formData.email);

    //setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {  
    var size = MediaQuery.of(context).size;
    double? widthScreen = 0;
    double? heightScreen = 0;

  
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: azulRoyalTopo,
        foregroundColor: Colors.white,
        title: Text(
          "Login",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/fundos/FUNDO_BIOSAT_APP_640.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        height: 100,
                        child: Image.asset('assets/images/logos/Logo_Biosat_PaginaInicial_02.png'),
                      ),
                      AuthForm(
                        onSubmit: _handleSubmit,
                      ),
                      if (_isLoading)
                        Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
