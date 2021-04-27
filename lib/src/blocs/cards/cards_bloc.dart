import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cards_event.dart';
part 'cards_state.dart';

class CardsBloc extends Bloc<CardsEvent, CardsState> {

    CardsBloc() : super(CardsState());

  @override
  Stream<CardsState> mapEventToState(CardsEvent event) async* {
      if (event is OnInitialState) {
          yield state.initialState();
          
      } else if (event is OnRefreshPosition) {
        yield state.copyWith(
          currentElement: state.cardsArray.elementAt(event.position)
        );

      } else if (event is OnRefreshFavoriteCard) {
        yield state.copyWith(
          favoriteCard : event.favoriteCard
        );

      } else if (event is OnRemoveCard) {
        List<int> list = removeElementFromList(state.cardsArray);
        yield state.copyWith(
          cardsArray: list,
          currentElement: list.length > 0 ? list.elementAt(0) : 0
        );
      }
  }

  List<int> removeElementFromList(List<int> cards) {
    List <int> list = [];
    var it = cards.iterator;

    while (it.moveNext()) {
      if (it.current != state.currentElement) {
          list.add(it.current);
      }
    }
    return list;
  }
}