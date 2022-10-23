import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '.evn.dart';
import 'directinos_model.dart';

class DirectionsRepository{
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio _dio = Dio();

  Future<Directions?> getDiretions({
    required LatLng orgin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin':'${orgin.latitude},${orgin.longitude}',
        'destination':'${destination.latitude},${destination.longitude}',
        'key':googleAPIKey,
      }
    );

    if(response.statusCode == 200){
      return Directions.fromMap(response.data);
    }
    return null;
  }
}