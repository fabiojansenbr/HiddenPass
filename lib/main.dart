import 'package:flutter/material.dart';

import 'package:hiddenpass/global.dart';
import 'package:hiddenpass/Pages/signUp.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HiddenPass',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final spaceVertical = SizedBox(height: 25.0);

    final emailField = Material(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'E-mail',
            contentPadding: EdgeInsets.all(15.0),
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white, fontSize: 14.0)),
      ),
    );

    final passwordField = Material(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Senha',
            contentPadding: EdgeInsets.all(15.0),
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white, fontSize: 14.0)),
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: primaryColor,
      child: MaterialButton(
        minWidth: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        onPressed: () {},
        child: Text('ENTRAR',
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg_hiddenpass.png'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Image(
                    image: AssetImage('assets/images/logo_hiddenpass.png'),
                    width: 110.0),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Column(
                  children: <Widget>[
                    emailField,
                    spaceVertical,
                    passwordField,
                    spaceVertical,
                    Text('Esqueceu Sua Senha?',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
                    spaceVertical,
                    loginButton,
                  ],
                ),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: <Widget>[
                    Divider(color: Colors.black.withOpacity(0.3)),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Matenha suas contas protegidas ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.0)),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => SignUpPage()
                            ));
                          },
                          child: Text('Cadastre-se',
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 12.0)),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
