part of 'cards_bloc.dart';

@immutable
abstract class CardsEvent {}

class OnInitialState extends CardsEvent{
}

class OnRefreshPosition extends CardsEvent{
  final int position;
  OnRefreshPosition(this.position);
}

class OnRefreshFavoriteCard extends CardsEvent{
  final int favoriteCard;
  OnRefreshFavoriteCard(this.favoriteCard);
}

class OnRemoveCard extends CardsEvent{
}