import 'package:bloc_paggination/service/model/posts.model.dart';
import 'package:bloc_paggination/service/model/json_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostService {
  PostService({required this.dio}) {
    dio.options.baseUrl = 'https://jsonplaceholder.typicode.com/';
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.responseType = ResponseType.json;
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      logPrint: (Object object) {
        debugPrint('\x1B[32m$object\x1B[0m');
      },
    ));
  }

  /// [dio] is the [Dio] instance used to make all the requests.
  /// [dio] is required to make all the requests.
  ///
  final Dio dio;

  Future<JsonResponse> posts({required int page, required int limit}) async {
    try {
      final response = await dio.get(
        'posts',
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final data = List<PostsModel>.from(
          response.data?.map(
                (dynamic item) => PostsModel.fromJson(item),
              ) ??
              <PostsModel>[],
        );
        return JsonResponse.success(
          message: 'Posts Fetched Successfully!',
          data: data,
        );
      } else if (response.statusCode == 422) {
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: 'Validation error: ',
        );
      } else {
        final error = response.data?["message"]?.toString();
        return JsonResponse.failure(
          statusCode: response.statusCode ?? 500,
          message: error ?? 'something went wrong!',
        );
      }
    } on DioException catch (e) {
      final error = e.response?.data["message"]?.toString();
      return JsonResponse.failure(
        message: error.toString(),
        statusCode: e.response?.statusCode ?? 500,
      );
    } on Exception catch (_) {
      return JsonResponse.failure(
        message: 'Something went wrong!',
      );
    }
  }
}
