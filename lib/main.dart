import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/blocs/map/map_bloc.dart';
import 'package:share_a_car/pages/add_card.dart';
import 'package:share_a_car/pages/cards_page.dart';
import 'package:share_a_car/pages/home_page.dart';
import 'package:share_a_car/pages/login_page.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent
    ));

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: ( _ ) => MapBloc() ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Share a Car',
          initialRoute: '/',
          routes: {
            '/': ( BuildContext context ) => HomePage(),
            'login': ( BuildContext context ) => LoginPage(),
            'cards': ( BuildContext context ) => CardsPage(),
            'addCard': ( BuildContext context ) => AddCard(),
          },
          theme: ThemeData(
            primaryColor: Colors.white,
          ),
        ),
    );
  }
}