
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/login/login_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/pages/home/components/validate_config.dart';
import 'package:share_a_car/src/common/widgets/navigate_fadein.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginBloc _loginBloc;

  bool obscurePasswordText = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }
  
  @override
  void dispose() {
    _loginBloc.add(OnInitialState());
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state.credentialsAreValid){
            SharedPreferencesUtils.setValue(Constants.USER_ID, state.userId).then((value) => {
                Navigator.of(context).pushAndRemoveUntil(
                  navigateFadeIn(context, ValidateConfigPage()),
                  (Route route) => false
                )
            });
            SharedPreferencesUtils.setValue(Constants.USERNAME, _usernameController.text);
          }
        },
        builder: ( _ , state) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(4,100,52, 1.0),
            body: Stack(
                children: [
                  _createBackground(context),
                  _loginForm(context, state),
                ],
            )
          );
        }
    );
  }

  Widget _createBackground(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final purpleBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white
      ),
    );

    return Stack(
      children: [
        purpleBackground,
        Container(
          padding: EdgeInsets.only(top: 110.0),
          child: Column(
            children: [
              Image.asset(Constants.SPLASH_SCREEN, scale: 3.0),
              SizedBox(
                height: 15.0,
                width: double.infinity,
              ),
            ],
          )
        )
      ]
    );
  }

  Widget _loginForm(BuildContext context, LoginState state) {

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
            margin: EdgeInsets.symmetric(vertical: 20.0),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Ingreso', style: TextStyle(fontSize: 20.0, color: Colors.black)),
                  SizedBox(
                    height: 30.0,
                  ),
                   if (state.isThereAnError) Container(padding: EdgeInsets.only(left: 15, right: 15), child: Text(state.errorMessage, style: TextStyle(fontSize: 14.0, color: Colors.red))),
                  _createUserField(state),
                  SizedBox(
                    height: 30.0,
                  ),
                  _createPassword(state),
                  SizedBox(
                    height: 30.0,
                  ),
                  _createButton(context, state),
                ],
              ),
            ),
          ),
          TextButton(
            child: Text('Regístrese aquí', style: TextStyle(color: Colors.white)),
            onPressed: () {
              _loginBloc.add(OnInitialState());
              Navigator.of(context).pushNamed("userRegistration");
              _formKey.currentState.reset();
            },
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Widget _createUserField(LoginState state) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
          ],
          controller: _usernameController,
          enabled: !state.validatingCredentials,
          validator: (value) {
            if (value.trim().length < 1) {
              return 'Debe ingresar un usuario';
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.person, color: Colors.green),
            labelText: 'Usuario',
          ),
        ),
      ),
    );
  }

  Widget _createPassword(LoginState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        enabled: !state.validatingCredentials,
        controller: _passwordController,
        validator: (value) {
         if (value.trim().length < 1) {
            return 'Debe ingresar una contraseña';
          }
          return null;
        },
        obscureText: obscurePasswordText,
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Colors.green),
          labelText: 'Contraseña',
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscurePasswordText = !obscurePasswordText;
              });
            },
            icon: Icon(obscurePasswordText ? Icons.visibility : Icons.visibility_off, color: Colors.grey)
          ),
        ),
      ),
    );
  }

  Widget _createButton(BuildContext context, LoginState state) {
    return !state.validatingCredentials ? ElevatedButton(
      style: ButtonStyle(
        enableFeedback: true,
        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(112,200,40, 1.0)),
        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          )  
        )
      ),
      onPressed: (){
        if(_formKey.currentState.validate()){
          _loginBloc.add(OnValidateForm(_usernameController.text, _passwordController.text));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Ingresar'),
      ),
    ): CircularProgressIndicator();
  }

   Widget buildLoadingForm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
      child: Row(
        children: [
          Text("Validando", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0)),
          SizedBox(width: 10.0),
          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(backgroundColor: Colors.white,))
        ]
      ),
    );
  }
}