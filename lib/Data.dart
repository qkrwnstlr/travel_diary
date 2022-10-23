import 'package:location/location.dart';

class DirectionData{
  final Place orign;
  final Place destination;
  final String mode;

  const DirectionData({
    required this.orign,
    required this.destination,
    required this.mode,
  });
}

class Place{
  final String placeID;
  final Location location;
  final List<String> types;

  const Place({
    required this.placeID,
    required this.location,
    required this.types,
  });
}
