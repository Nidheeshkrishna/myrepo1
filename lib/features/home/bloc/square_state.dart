part of 'square_bloc.dart';

enum SquareStatus { initial, success, failure, loggedOut }

class SquareState extends Equatable {
  final SquareStatus status;
  final List<SquareElement> posts;
  final bool hasReachedMax;
  const SquareState({
    this.status = SquareStatus.initial,
    this.posts = const <SquareElement>[],
    this.hasReachedMax = false,
  });

  SquareState copyWith({
    SquareStatus status,
    List<SquareElement> posts,
    bool hasReachedMax,
  }) {
    return SquareState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
