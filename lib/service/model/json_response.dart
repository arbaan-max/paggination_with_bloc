import 'package:equatable/equatable.dart';

/// [JsonResponse] is a class that contains the responses of server.
/// It contains the [data] and [message] of the response.
/// It contains the [statusCode] of the response.
/// It contains the [success] of the response.
class JsonResponse extends Equatable {
  /// [success] is the success of the response.
  /// It is true if the response is successful.
  /// It is false if the response is not successful.
  final bool success;

  /// [statusCode] is the status code of the response.
  /// It is the status code of the response.
  final int statusCode;

  /// [message] is the message for the response.
  /// It is the message for the response.
  final String message;

  /// [data] is the data of the response.
  /// It is the data of the response.
  final Object? data;

  /// [JsonResponse] constructor.
  const JsonResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
  });

  /// [JsonResponse.success] returns a [JsonResponse] with [success] set to true and [statusCode] set to 200.
  factory JsonResponse.success({String message = 'success', Object? data}) =>
      JsonResponse(
        success: true,
        statusCode: 200,
        message: message,
        data: data,
      );

  /// [JsonResponse.failure] returns a [JsonResponse] with [success] set to false and [statusCode] set to the provided [statusCode].
  /// [message] is set to the provided [message].
  factory JsonResponse.failure(
          {int statusCode = 500, String message = 'failure', Object? data}) =>
      JsonResponse(
        success: false,
        statusCode: statusCode,
        message: message,
        data: data,
      );

  /// [JsonResponse.fromJson] returns a [JsonResponse] from the provided [json] map.
  factory JsonResponse.fromJson(Map<String, dynamic> json) => JsonResponse(
        success: json['success'] ?? false,
        statusCode: json['code'] ?? 500,
        message: json['message'] ?? 'something went wrong!',
        data: json['data'],
      );

  /// [JsonResponse.copyWith] returns a [JsonResponse] with the provided [success], [statusCode], [message] and [data].
  /// [success] is optional.
  /// [statusCode] is optional.
  /// [message] is optional.
  /// [data] is optional.
  JsonResponse copyWith(
          {bool? success, int? statusCode, String? message, Object? data}) =>
      JsonResponse(
        success: success ?? this.success,
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  /// [JsonResponse.toJson] returns a [Map] representation of the [JsonResponse].
  Map<String, dynamic> toJson() => {
        'success': success,
        'code': statusCode,
        'message': message,
        'data': data,
      };

  @override
  List<Object> get props => [success, statusCode, message];

  @override
  String toString() =>
      'JsonResponse { success: $success, statusCode: $statusCode, message: $message, data: $data }';
}
