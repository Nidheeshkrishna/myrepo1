part of 'square_bloc.dart';

abstract class SquareEvent extends Equatable {
  const SquareEvent();
}
class FetchSquares extends SquareEvent {
  int page;

  FetchSquares(this.page);

  @override
  List<Object> get props => [page];
}