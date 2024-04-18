part of 'posts_bloc.dart';

class PostsState extends Equatable {
  const PostsState({
    this.postsData = const <PostsModel>[],
    this.isLoading = false,
    this.message = '',
    this.error = '',
    this.hasReachedMax = false,
    this.page = 0,
    this.limit = 10,
  });

  final List<PostsModel> postsData;
  final bool isLoading;
  final String message;
  final String error;
  final bool hasReachedMax;
  final int page;
  final int limit;

  PostsState copyWith({
    List<PostsModel>? postsData,
    bool? isLoading,
    String? message,
    String? error,
    bool? hasReachedMax,
    int? page,
    int? limit,
  }) =>
      PostsState(
        postsData: postsData ?? this.postsData,
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        page: page ?? this.page,
        limit: limit ?? this.limit,
      );

  /// fromJson and toJson are not necessary, but they can help in case you need to use Hyderated Bloc
  /// for local Storing the data in Cache
  factory PostsState.fromJson(Map<String, dynamic> json) => PostsState(
        postsData: List<PostsModel>.from(
          json["postsData"]?.map((x) => PostsModel.fromJson(x)) ?? <PostsModel>[],
        ),
      );

  Map<String, dynamic> toJson() => {
        "postsData": postsData.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        postsData,
        isLoading,
        message,
        error,
        hasReachedMax,
        page,
        limit,
      ];
}
