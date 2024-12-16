import 'package:flutter_config/flutter_config.dart';
import 'package:live_flight_tracker/models/place_model.dart';
import 'package:live_flight_tracker/models/place_search_model.dart';

import 'package:live_flight_tracker/services/dio_client.dart';

class MapRepository {
  static String key = FlutterConfig.get('GOOGLE_MAP_API_KEY');
  Future<List<PlaceSearchModel>> getAutocomplete(String search) async {
    if (search.isEmpty) {
      return <PlaceSearchModel>[];
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:au&key=$key';
    var response = await DioClient().get(url);
    var json = response.data;
    var jsonResults = json['predictions'] as List;
    return jsonResults
        .map((place) => PlaceSearchModel.fromJson(place))
        .toList();
  }

  Future<Place> getPlace(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await DioClient().get(url);
    var json = response.data;
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
