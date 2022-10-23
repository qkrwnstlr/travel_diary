import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:travel_diary/directinos_model.dart';
import 'package:travel_diary/directions_repository.dart';

class Direction extends StatefulWidget {
  const Direction({Key? key}) : super(key: key);

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  static const _defaultZoom = 11.5;
  static const _initalCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: _defaultZoom, // Max = 21
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  Directions? _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<LatLng> _currentLocation() async {
    LocationData currentLocation;
    var location = new Location();
    currentLocation = await location.getLocation();
    return LatLng(currentLocation.latitude!, currentLocation.longitude!);
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        _destination = null;
        _info = null;
      });
    } else {
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });
      try {
        final directions = await DirectionsRepository()
            .getDiretions(orgin: _origin!.position, destination: pos);
        setState(() => {if (directions != null) _info = directions});
        CameraUpdate.newLatLngBounds(_info!.bounds, 100.0);
      } catch (e){
        const snackBar = SnackBar(
          content: Text('No Data for routs'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _origin = null;
          _destination = null;
          _info = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            // 확대, 축소 버튼
            initialCameraPosition: _initalCameraPosition,
            // 시작 위치
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            polylines: {
              if(_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList()
                )
            },
            onTap: (pos) => _addMarker(pos),
          ),
          if(_info != null) Positioned(
            top: 20.0,
            child: Container(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const[
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ]
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () async => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: await _currentLocation(), zoom: _defaultZoom),
          ),
        ),
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }
}
