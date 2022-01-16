import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/home/models/square.dart';

import 'package:flutter_application_2/features/home/respositories/home_repo.dart';

part 'square_event.dart';

part 'square_state.dart';

class SquareBloc extends Bloc<SquareEvent, SquareState> {
  final HomeRepo _repo;

  SquareBloc(HomeRepo repo)
      : this._repo = repo,
        super(const SquareState());

  @override
  Stream<SquareState> mapEventToState(
    SquareEvent event,
  ) async* {
    if (event is FetchSquares) {
      yield await _mapPostFetchedToState(state, event);
    }
  }

  Future<SquareState> _mapPostFetchedToState(SquareState state, event) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == SquareStatus.initial) {
        final posts = await _fetchPosts(0, event);
        return state.copyWith(
          status: SquareStatus.success,
          posts: posts,
          hasReachedMax: false,
        );
      }

      final posts = await _fetchPosts(state.posts.length, event);
      return posts == null
          ? state.copyWith(status: SquareStatus.failure)
          : posts.isEmpty
              ? state.copyWith(hasReachedMax: true)
              : state.copyWith(
                  status: SquareStatus.success,
                  posts: List.of(state.posts)..addAll(posts),
                  hasReachedMax: false,
                );
    } on Exception {
      return state.copyWith(status: SquareStatus.failure);
    }
  }

  Future<List<SquareElement>> _fetchPosts(
      int startIndex, SquareEvent event) async {
    var _squareResponse =
        await _repo.fetchSquares((startIndex / 20).round() + 1);

    return _squareResponse.square;
  }
}
