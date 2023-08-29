import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(                       
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Login",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/fundoTelaPrincipalBiosat3.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 250,
                        height: 100,
                        child: Image.asset('assets/images/logo_Biosat.png'),
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
