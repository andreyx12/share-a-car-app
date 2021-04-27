part of 'cards_bloc.dart';

class CardsState {
  
   int position;
   int currentElement;
   int favoriteCard;
   List<int> cardsArray;

  CardsState({
    this.position = 0,
    this.favoriteCard = 2,
    this.currentElement = 2,
    List<int> cardsArray
  }): this.cardsArray = cardsArray ?? [2,1,3];

  CardsState copyWith({
    int position,
    int currentElement,
    int favoriteCard,
    List<int> cardsArray,
  }) => CardsState(
    position: position ?? this.position,
    favoriteCard: favoriteCard ?? this.favoriteCard,
    currentElement: currentElement ?? this.currentElement,
    cardsArray: cardsArray ?? this.cardsArray,
  );

  CardsState initialState() => new CardsState();
}
