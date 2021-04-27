import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/user_config/user_config_bloc.dart';
import 'package:share_a_car/src/common/utils/constants.dart';
import 'package:share_a_car/src/common/utils/shared_preferences_utils.dart';
import 'package:share_a_car/src/models/user_config/user_config.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {

  UserConfigBloc _userConfigBloc;

  TextEditingController _identificationController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastName1Controller = TextEditingController();
  TextEditingController _lastName2Controller = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final _editformKey = GlobalKey<FormState>();

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  String username;

  @override
  void initState() {
    super.initState();
    username = SharedPreferencesUtils.getValue(Constants.USERNAME);
    _userConfigBloc = BlocProvider.of<UserConfigBloc>(context);
    context.read<UserConfigBloc>().add(OnGetUserInformation());
  }

  @override
  void dispose() {
    _userConfigBloc.add(OnInitialState());
    _identificationController.dispose();
    _nameController.dispose();
    _lastName1Controller.dispose();
    _lastName2Controller.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  return BlocBuilder<UserConfigBloc, UserConfigState>(
    builder: ( _ , state) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                expandedHeight: 190.0,
                backgroundColor: Color.fromRGBO(5, 128, 66, 1.0),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(username),
                  centerTitle: true,
                  background: Hero(
                    tag: "UserSettings",
                      child: FadeInImage(
                      width: double.infinity,
                      fadeInDuration: Duration(milliseconds: 150),
                      image: AssetImage(Constants.PLACEHOLDER_PROFILE_IMAGE_PATH),
                      placeholder: AssetImage(Constants.PLACEHOLDER_PROFILE_IMAGE_PATH),
                    ),
                  ),
                ),
              ),
              getSliverList(state),
            ],
          ),
          floatingActionButton: state.showEditForm ? null : FloatingActionButton(
            onPressed: () { 
              _userConfigBloc.add(OnShowEditForm());
            },
            child: Icon(Icons.edit, color: Colors.white,),
          ),
          bottomNavigationBar: bottomButton(context, state)
        );
      },
    );
  }

  Widget getSliverList (UserConfigState state) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          state.infoWasLoaded ? _validateScreenToShow(state) : Center(heightFactor: 10.0, child: CircularProgressIndicator())
        ]
      )
    );
  }

  Widget _validateScreenToShow(UserConfigState state) {
    if (state.showEditForm) {
      return _editUserInfo(state);
    } else {
      return _getUserInfo(state);
    }
  }

  Widget _editUserInfo(UserConfigState state) {

    _loadControllerWithInfo(state);

    return Form(
      key: _editformKey,
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.green),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.account_circle, size: 40),
                      title: Text('Usuario'),
                      subtitle: Text(state.userConfig.username),
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: !state.validatingEditForm,
                        controller: _identificationController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.badge),
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
                        enabled: !state.validatingEditForm,
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
                        enabled: !state.validatingEditForm,
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
                        enabled: !state.validatingEditForm,
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
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        enabled: !state.validatingEditForm,     
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
                        enabled: !state.validatingEditForm,     
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
                          icon: Icon(Icons.alternate_email),
                          labelText: 'Correo'
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getUserInfo(UserConfigState state) {

    if (state.userConfig.errorMessage == null) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_circle, size: 40),
                    title: Text('Usuario'),
                    subtitle: Text(state.userConfig.username),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.badge, size: 40),
                    title: Text('Identificación'),
                    subtitle: Text(state.userConfig.identification),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Text('Nombre'),
                    subtitle: Text(state.userConfig.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Text('Apellido 1'),
                    subtitle: Text(state.userConfig.lastName1),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, size: 40),
                    title: Text('Apellido 1'),
                    subtitle: Text(state.userConfig.lastName2),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.call, size: 40),
                    title: Text('Teléfono'),
                    subtitle: Text(state.userConfig.phoneNumber),
                  ),
                  ListTile(
                    leading: Icon(Icons.alternate_email, size: 40),
                    title: Text('Correo'),
                    subtitle: Text(state.userConfig.email),
                  ),
                ],
              )
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.error, size: 40, color: Colors.red,),
                        title: Text('Error ' + state.userConfig.errorCode),
                        subtitle: Text(state.userConfig.errorMessage),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          RawMaterialButton(
            fillColor: Colors.white,
            shape: CircleBorder(),
            onPressed: () {
              _userConfigBloc.add(OnInitialState());
              _userConfigBloc.add(OnGetUserInformation());
            }, 
            child: Icon(
              Icons.refresh,
              size: 30.0,
            )
          )
        ]
      );
    }   
  }

  Widget bottomButton(BuildContext context, UserConfigState state) {
      return state.showEditForm ? SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 5.0, left: 5.0, bottom: Platform.isAndroid ? 5.0 : 0.0),
          child: ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                enableFeedback: true,
                minimumSize: MaterialStateProperty.all(Size.fromHeight(50.0)),
                backgroundColor:  MaterialStateProperty.all(Colors.green[900]),
              ),
              child: !state.validatingEditForm ? Text('Guardar cambios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0)) : buildLoadingForm(),
              onPressed: !state.validatingEditForm ? () {
                if(_editformKey.currentState.validate()){
                  UserConfig userConfigRequest = new UserConfig(
                    userId: int.parse(SharedPreferencesUtils.getValue(Constants.USER_ID)),
                    username: state.userConfig.username,
                    password: state.userConfig.password,
                    identification: _identificationController.text,
                    name: _nameController.text,
                    lastName1: _lastName1Controller.text,
                    lastName2: _lastName2Controller.text,
                    phoneNumber: _phoneNumberController.text,
                    email: _emailController.text,
                  );
                   _userConfigBloc.add(OnUpdateUserInfo(userConfigRequest));
                }
              } : null,
            ),
        ),
      ) : null;
  }

  Widget buildLoadingForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Guardando cambios", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0)),
        SizedBox(width: 10.0),
        SizedBox(width: 20, height: 20, child: CircularProgressIndicator(backgroundColor: Colors.white,))
      ]
    );
  }

  void _loadControllerWithInfo(UserConfigState state) {
    if (!state.validatingEditForm){
      _identificationController.text = state.userConfig.identification;
      _nameController.text = state.userConfig.name;
      _lastName1Controller.text = state.userConfig.lastName1;
      _lastName2Controller.text = state.userConfig.lastName2;
      _phoneNumberController.text = state.userConfig.phoneNumber;
      _emailController.text = state.userConfig.email;
    }
  }
}