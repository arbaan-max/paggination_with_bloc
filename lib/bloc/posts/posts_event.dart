part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class GetPosts extends PostsEvent {
  const GetPosts({this.refresh = false});
  final bool refresh;

  @override
  List<Object> get props => [];
}
