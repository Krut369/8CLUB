import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://staging.chamberofsecrets.8club.co/v1/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
