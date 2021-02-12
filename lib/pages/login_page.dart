
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _createBackground(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _createBackground(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final purpleBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    return Stack(
      children: [
        purpleBackground,
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text("Login", style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          )
        )
      ]
    );
  }

  Widget _loginForm(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180,
            )
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: [
                Text('Ingreso', style: TextStyle(fontSize: 20.0),),
                SizedBox(
                  height: 30.0,
                ),
                _createEmail(),
                SizedBox(
                  height: 30.0,
                ),
                _createPassword(),
                SizedBox(
                  height: 30.0,
                ),
                _createButton(context),
              ],
            ),
          ),
          Text('¿Olvidó la contraseña?'),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Widget _createEmail() {

    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.green),
                hintText: 'sample@gmail.com',
                labelText: 'Correo electrónico',
              ),
              //onChanged: (value) => bloc.changeEmail(value),
            ),
          ),
        );
      }
    );
  }

  Widget _createPassword() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.green),
          labelText: 'Contraseña'
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context) {

    return RaisedButton(
      elevation: 0.0,
      color: Colors.green,
      textColor: Colors.white,
      onPressed: (){
        Navigator.of(context).pushNamed('/');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Ingresar'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
    );
  }
}