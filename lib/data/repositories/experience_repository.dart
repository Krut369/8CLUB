import 'package:dio/dio.dart';
import '../models/experience_model.dart';
import '../services/api_service.dart';

class ExperienceRepository {
  Future<List<Experience>> getExperiences() async {
    final Response res =
    await dio.get('experiences', queryParameters: {'active': true});
    final List data = res.data['data']['experiences'];
    return data.map((e) => Experience.fromJson(e)).toList();
  }
}
