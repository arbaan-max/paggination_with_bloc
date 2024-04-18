import 'package:bloc_paggination/service/api/posts.service.dart';
import 'package:bloc_paggination/service/model/json_response.dart';

abstract class PostsRepository {
  Future<JsonResponse> posts({required int page, required int limit});
}

class PostsRepoImplements implements PostsRepository {
  PostsRepoImplements({required this.service});
  final PostService service;

  @override
  Future<JsonResponse> posts({required int page, required int limit}) => service.posts(page: page, limit: limit);
}
