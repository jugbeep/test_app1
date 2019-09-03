import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../provider/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;

  Map<String, String> _authData = {
    'userName': '',
    'password': '',
  };

  void _showErrAlert(message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('There was an error.'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['userName'], _authData['password']);
      setState(() {
        _isLoading = false;
      });
    } on HttpException catch (err) {
      _showErrAlert(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                elevation: 8,
                child: Container(
                  height: 350,
                  constraints: BoxConstraints(minHeight: 350),
                  width: deviceSize.width * 0.8,
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'User name'),
                          keyboardType: TextInputType.text,
                          // validator: (value) {
                          //   if (value.isEmpty || !value.contains('@')) {
                          //     return 'Invalid email!';
                          //   }
                          // },
                          onSaved: (val) {
                            _authData['userName'] = val;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'password'),
                          obscureText: true,
                          // validator: (value) {
                          //   if (value.isEmpty || value.length < 5) {
                          //     return 'Password is too short!';
                          //   }
                          //   return null;
                          // },
                          onSaved: (val) {
                            _authData['password'] = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            onPressed: _submit,
                            child: Text("Login"),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
