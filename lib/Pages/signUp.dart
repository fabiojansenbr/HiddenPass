import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hiddenpass/global.dart';
import 'package:hiddenpass/main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  String _name;
  String _email;
  String _password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(String email, String password) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<void> saveUserOnDb(String email, String uid) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection('users').document(uid);
      await reference.setData({
        "name": _name,
        "email": _email,
        "create_date": DateTime.now()
      }).catchError((e) {
        print(e);
      });
    });
  }

  void onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(backgroundColor: secondaryColor),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Salvando Informacoes',
                    style: TextStyle(fontSize: 16.0)),
              )
            ],
          ),
        ),
      ),
    );
  }

  final spaceVertical = SizedBox(height: 25.0);

  final InputDecoration inputDecoration = InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
      fillColor: Colors.grey,
      contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
      counterText: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Text('Cadastre-se'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0.0),
                  child: Form(
                    autovalidate: _autoValidate,
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Material(
                          child: TextFormField(
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Por favor preencha esse campo';
                              } else {
                                if (value.trim().length < 5) {
                                  return 'Informe um nome com pelo menos 5 caracteres';
                                } else {
                                  return null;
                                }
                              }
                            },
                            onSaved: (String value) {
                              _name = value;
                            },
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            maxLength: 80,
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: inputDecoration.copyWith(
                                hintText: 'Nome', labelText: 'Nome'),
                          ),
                        ),
                        spaceVertical,
                        Material(
                          child: TextFormField(
                            validator: (value) {
                              if (value.trim().isNotEmpty) {
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);

                                if (!regex.hasMatch(value)) {
                                  return 'E-mail informado invalido';
                                }
                              } else {
                                return 'Por favor preencha esse campo';
                              }
                            },
                            onSaved: (String value) {
                              _email = value;
                            },
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 80,
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: inputDecoration.copyWith(
                                hintText: 'E-mail', labelText: 'E-mail'),
                          ),
                        ),
                        spaceVertical,
                        Material(
                          child: TextFormField(
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'Por favor preencha esse campo';
                              } else {
                                if (value.trim().length < 8) {
                                  return 'Informe uma senha com pelo menos 8 caracteres';
                                } else {
                                  return null;
                                }
                              }
                            },
                            onSaved: (String value) {
                              _password = value;
                            },
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            maxLength: 24,
                            style: TextStyle(color: Colors.grey[700]),
                            decoration: inputDecoration.copyWith(
                                hintText: 'Senha', labelText: 'Senha'),
                          ),
                        ),
                        spaceVertical,
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor,
                          child: MaterialButton(
                            minWidth: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                onLoading();

                                _formKey.currentState.save();

                                _formKey.currentState.reset();

                                signUpUser(_email, _password).then((uid) {
                                  saveUserOnDb(_email, uid).then((result) {
                                    Navigator.of(context).pop();

                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        child: Dialog(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  "Casdastro Realizado com Sucesso!",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey[700]),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 15.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          PageRouteBuilder(pageBuilder:
                                                              (BuildContext context, Animation<double> animation,
                                                                  Animation<double> secondaryAnimation) {
                                                        return LoginPage();
                                                      }),
                                                          (Route<dynamic> r) => false);

                                                    },
                                                    child: Text(
                                                      "Voltar para o Login",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 18.0),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  }).catchError((onError) {
                                    print(onError);
                                  });
                                }).catchError((onError) {
                                  print(onError);
                                });
                              } else {
                                setState(() {
                                  _autoValidate = true;
                                });
                              }
                            },
                            child: Text('CONTINUAR',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
