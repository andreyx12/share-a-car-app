
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_a_car/src/blocs/cards/cards_bloc.dart';
import 'package:share_a_car/src/pages/cards/components/add_card.dart';

class CardsPage extends StatefulWidget {
  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {

  CarouselController controller = CarouselController();

  CardsBloc cardsBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    cardsBloc = BlocProvider.of<CardsBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    cardsBloc.add(OnInitialState());
  }
  
  @override
  Widget build(BuildContext context) {

     return  BlocBuilder<CardsBloc, CardsState>(
        builder: ( _ , state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text("Mis tarjetas"),
            ),
            body: Column(
              children: [
                _getCarousel(state),
                _showCarInfo(context, state),
              ]
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                _addCard(context, false);
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        }
    );
  }

  Widget _getCarousel(CardsState state) {
    return state.cardsArray.length <= 0 ? Container() : Container(
      padding: EdgeInsets.only(top: 40.0),
      child: CarouselSlider(
        carouselController: controller,
        options: CarouselOptions(
          onPageChanged: (i, _) {
            print(i);
            cardsBloc.add(OnRefreshPosition(i));
          }
        ),
        items: state.cardsArray.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Image.asset(
                  "assets/images/card$i.png",
                  height: 300,
                  width: 400,
                ),
              );
            }
          );
        }).toList(),
      ),
    );
  }

  Widget _showCarInfo(BuildContext context, CardsState state) {
    switch(state.currentElement) {
      case 1:
          return _buildCard(context, state, "Master Card", "5412 7500 1234 5678", "Luis Mora Torres", "232");
      case 2:
          return _buildCard(context, state, "Visa", "4538 1234 5678 9012", "Luis Mora Torres", "786");
      case 3:
        return _buildCard(context, state, "Visa", "4234 1234 1246 7867", "Miguel Torres Núñez", "289");
      default:
        return _buildCard(context, state, "Master Card", "9876 5678 2312 0923", "Luis Mora Torres", "543");
    }
  }

  void _editCard(BuildContext context, CardsState state) {
    switch(state.currentElement) {
      case 1:
          _addCard(context, true, brand: "Master Card", cardNumber: "5412 7500 1234 5678", owner: "Luis Mora Torres", cvv: "232");
          break;
      case 2:
          _addCard(context, true, brand: "Visa", cardNumber: "4538 1234 5678 9012", owner: "Luis Mora Torres", cvv: "786");
          break;
      case 3:
        _addCard(context, true, brand: "Visa", cardNumber: "4234 1234 1246 7867", owner: "Miguel Torres Núñez", cvv: "289");
        break;
      default:
         _addCard(context, true, brand: "Master Card", cardNumber: "5412 7500 1234 5678", owner: "Luis Mora Torres", cvv: "232");
        break;
    }
  }

  Widget _buildCard(BuildContext context, CardsState state, String brand, String cardNumber, String owner, String cvv) {
     return state.cardsArray.length <= 0 ? _emptyCardsScreen() : Container(
       margin: EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon:  Icon(Icons.star, color: state.currentElement == state.favoriteCard ? Colors.orange : Colors.black),
                  onPressed: (){
                   cardsBloc.add(OnRefreshFavoriteCard(state.currentElement));
                  }
                ),
                IconButton(
                  icon:  Icon(Icons.edit),
                  onPressed: (){
                    _editCard(context, state);
                  }
                ),
                  IconButton(
                  icon:  Icon(Icons.delete),
                  onPressed: (){
                    cardsBloc.add(OnRemoveCard());
                    controller.jumpToPage(0);
                  }
                ),
              ]
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  ListTile(
                    leading: Icon(Icons.credit_card, size: 40),
                    title: Text('Marca'),
                    subtitle: Text(brand),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card, size: 40),
                    title: Text('Número de tarjeta'),
                    subtitle: Text(cardNumber),
                  ),
                  ListTile(
                    leading: Icon(Icons.security, size: 40),
                    title: Text('CVV'),
                    subtitle: Text(cvv),
                  ),
                   ListTile(
                    leading: Icon(Icons.account_circle, size: 40),
                    title: Text('Propietario'),
                    subtitle: Text(owner),
                  ),
                ],
              ),
            ),
          ]
      ),
     );
  }

  Widget _emptyCardsScreen() {
    return Container(
      margin: EdgeInsets.only(top: 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "assets/images/empty-card.png",
            scale: 3,
          ),
          SizedBox(height: 10.0),
          Text("- No hay tarjetas registradas - ", style: TextStyle(fontWeight: FontWeight.w500))
        ],
      )
    );
  }

  void _addCard(BuildContext context, bool edit, {String brand, String cardNumber, String owner, String cvv}) {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return Dialog(
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.green),
                child: Form(
                  key: _formKey,
                  child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 430
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text("Datos de la tarjeta", style: TextStyle(fontSize: 18),)
                          ),
                          SizedBox(height: 20.0),

                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            initialValue: edit ? owner : null,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Propietario de la tarjeta'
                            ),
                            validator: (value) {
                              if (value.trim().length < 1) {
                                return 'Debe ingresar el nombre del propietario';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            initialValue: edit ? cardNumber : null,
                            decoration: InputDecoration(
                              icon: Icon(Icons.credit_card),
                              labelText: 'Número de tarjeta'
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim().length < 1) {
                                return 'Debe ingresar un número de tarjeta';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            initialValue: edit ? cvv : null,
                            decoration: InputDecoration(
                              icon: Icon(Icons.security),
                              labelText: 'CVV'
                            ),
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.trim().length < 1) {
                                return 'Debe ingresar un CVV válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.0),
                          
                          Center(
                            child: ElevatedButton(
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
                                if (_formKey.currentState.validate()) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
                                child: Text(edit ? 'Actualizar ': 'Registrar'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                 ),
                ),
            ),
        );
    });
  }
}