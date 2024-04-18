import 'dart:async';

import 'package:bloc_paggination/service/model/posts.model.dart';
import 'package:bloc_paggination/service/repository/posts.repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends HydratedBloc<PostsEvent, PostsState> {
  PostsBloc({required this.repository}) : super(const PostsState()) {
    on<GetPosts>(_onGetPosts);
  }
  final PostsRepository repository;

  /// Event handler for fetching posts.
  ///
  /// This method is called when a [GetPosts] event is dispatched to the bloc.
  /// It fetches posts data from the repository based on the current page and limit.
  /// If the `refresh` flag is true, it emits a new [PostsState] with default values to indicate a refresh operation.
  /// If the `hasReachedMax` flag is true, indicating that all posts have been loaded, the method returns early.
  /// Otherwise, it emits a loading state and attempts to fetch posts from the repository.
  /// Upon successful response, it updates the state with the fetched posts, increments the page number,
  /// and checks if all posts have been loaded based on the limit.
  /// If there's an error during the fetch operation, it emits an error state with the error message.
  FutureOr<void> _onGetPosts(GetPosts event, Emitter<PostsState> emit) async {
    /// Make the refresh True When Ever You Want to reload the API with page 0
    if (event.refresh) {
      emit(const PostsState());
    }
    if (state.hasReachedMax) return;
    emit(state.copyWith(isLoading: true, error: '', message: ''));

    /// Storing the Previously loaded Data in the State List
    final oldItems = state.postsData;
    try {
      final response = await repository.posts(
        page: state.page,
        limit: state.limit,
      );
      if (response.success) {
        final items = response.data as List<PostsModel>;
        emit(state.copyWith(
          isLoading: false,
          postsData: [...oldItems, ...items],
          hasReachedMax: items.isEmpty || items.length < state.limit,
          page: state.page + 1,
        ));
      } else {
        emit(state.copyWith(isLoading: false, error: response.message));
      }
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Converts a JSON map to a [PostsState] object.
  ///
  /// This method is called by [HydratedBloc] when loading the state from storage.
  /// It takes a [json] map representing the serialized state and returns a [PostsState] object.
  @override
  PostsState? fromJson(Map<String, dynamic> json) => PostsState.fromJson(json);

  /// Converts a [PostsState] object to a JSON map.
  ///
  /// This method is called by [HydratedBloc] when saving the state to storage.
  /// It takes a [state] object and returns a JSON map representing the serialized state.
  @override
  Map<String, dynamic>? toJson(PostsState state) => state.toJson();
}
