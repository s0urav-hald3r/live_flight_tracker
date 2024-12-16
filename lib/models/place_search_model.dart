class PlaceSearchModel {
  final String? description;
  final String? placeId;

  PlaceSearchModel({this.description, this.placeId});

  factory PlaceSearchModel.fromJson(Map<String, dynamic> json) {
    return PlaceSearchModel(
        description: json['description'], placeId: json['place_id']);
  }
}
