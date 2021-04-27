
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/user_registration/user_registration_bloc.dart';
import 'package:share_a_car/src/models/login/user_registration.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {

  UserRegistrationBloc _userRegistrationBloc;
  
  final _formKey = GlobalKey<FormState>();

  bool obscurePasswordText = true;
  bool obscureConfirmPasswordText = true;

  final TextEditingController _identificationController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastName1Controller = TextEditingController();
  final TextEditingController _lastName2Controller = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userRegistrationBloc = BlocProvider.of<UserRegistrationBloc>(context);
  }
  
  @override
  void dispose() {
    _userRegistrationBloc.add(OnInitialState());
    _identificationController.dispose();
    _nameController.dispose(); 
    _phoneNumberController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
     _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     return BlocBuilder<UserRegistrationBloc, UserRegistrationState>(
        builder: ( _ , state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Registro del usuario"),
            ),
            body: getScreen(context, state),
            bottomNavigationBar: !state.formWasValidated ? bottomButton(context, state) : SizedBox()
          );
        }
    );
  }

  Widget getScreen (BuildContext context, UserRegistrationState state) {

    final size = MediaQuery.of(context).size;

    if (!state.formWasValidated) {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.green),
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  userInfoCard(state),
                  SizedBox(height: 10.0),
                  authenticationInfoCard(state),
                ],
              )
            ),
          ),
        )
      );
    } else {
      return Column(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green[400],
                  Colors.green[800]
                ]
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 110.0,
                  icon: Icon(Icons.check_circle_outline, color: Colors.white), 
                  onPressed: null
                ),
                SizedBox(height: 40.0),
                Text("¡Éxito!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0))
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Text("Registro fue realizado con éxito", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 20.0)),
                SizedBox(height: 15.0),
                Container(
                  padding: EdgeInsets.only(right: 30.0, left: 30.0),
                  child: Text("Diríjase al login e intente ingresar con las credenciales creadas.", style: TextStyle(color: Colors.grey[800])),
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    shape: MaterialStateProperty.all(StadiumBorder())
                  ),
                  onPressed: (){
                      Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                    child: Text('Regresar al login'),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget userInfoCard (UserRegistrationState state) {
    return  Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Datos de usuario", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,
              controller: _identificationController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Identificación'
              ),
              maxLength: 20,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar una identificación';
                }
                return null;
              },
            ),

            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,
              controller: _nameController,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar un nombre';
                }
                return null;
              },
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Nombre'
              ),
            ),

            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,
              controller: _lastName1Controller,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingrese el apellido 1';
                }
                return null;
              },
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido 1'
              ),
            ),

             TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,
              controller: _lastName2Controller,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingrese el apellido 2';
                }
                return null;
              },
              maxLength: 20,
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Apellido 2'
              ),
            ),

            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,     
              controller: _phoneNumberController,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar un teléfono';
                }
                return null;
              },
              maxLength: 8,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                icon: Icon(Icons.call),
                labelText: 'Teléfono'
              ),
            ),

            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,     
              controller: _emailController,
              onChanged: (value) {
                _emailController.value = _emailController.value.copyWith(text: value.toLowerCase());
              },
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar un correo';
                }
                return null;
              },
              maxLength: 40,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Correo'
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authenticationInfoCard (UserRegistrationState state) {
    return  Card(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Datos de autenticación", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            TextFormField(
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !state.validatingForm,
              controller: _userNameController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Usuario',
                errorText: state?.userRegistration?.errorCode != null ? 'Usuario ya registrado, ingrese uno distinto' : null,
              ),
              maxLength: 20,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar un usuario';
                }
                return null;
              },
            ),

            TextFormField(
              enabled: !state.validatingForm,   
              controller: _passwordController,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
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
              maxLength: 30,
              keyboardType: TextInputType.emailAddress,
              obscureText: obscurePasswordText,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe ingresar una contraseña';
                }
                if (value.trim().length < 5) {
                  return 'Debe ingresar una contraseña más larga';
                }
                return null;
              },
            ),

            TextFormField(
              enabled: !state.validatingForm,   
              controller: _confirmPasswordController,
              validator: (value) {
                if (value.trim().length < 1) {
                  return 'Debe confirmar la contraseña';
                } else if (_passwordController.text != value) {
                  return 'Contraseñas no coinciden';
                }
                return null;
              },
              maxLength: 30,
              obscureText: obscureConfirmPasswordText,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline),
                labelText: 'Confirmar contraseña',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirmPasswordText = !obscureConfirmPasswordText;
                    });
                  },
                  icon: Icon(obscureConfirmPasswordText ? Icons.visibility : Icons.visibility_off, color: Colors.grey)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButton(BuildContext context, UserRegistrationState state) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
        ),
        child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
              enableFeedback: true,
              minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
              backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
            ),
            child: !state.validatingForm ? Text('Registrar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)) : buildLoadingForm(),
            onPressed: !state.validatingForm ? () {
              if(_formKey.currentState.validate()){
                UserRegistration userRegistrationRequest = new UserRegistration(
                  identification: _identificationController.text,
                  name: _nameController.text,
                  lastName1: _lastName1Controller.text,
                  lastName2: _lastName2Controller.text,
                  phoneNumber: _phoneNumberController.text,
                  email: _emailController.text,
                  username: _userNameController.text,
                  password: _passwordController.text
                );       
                _userRegistrationBloc.add(OnRegisterUser(userRegistrationRequest));
              }
            } : null,
          ),
      ),
    );
  }

  Widget buildLoadingForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Realizando el registro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0)),
        SizedBox(width: 10.0),
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(backgroundColor: Colors.white,))
      ]
    );
  }
}