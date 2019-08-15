import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  double lat;
  double lon;

  //Marker list
  final Set<Marker> _markers = {};

  //defalut position
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_markers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMyLocation,
        label: Text('Where am I'),
        icon: Icon(Icons.location_on),
      ),
    );
  }

  Future<void> _goToMyLocation() async {
    _getLocation();
  }

  var location = new Location();

  _getLocation() async {
    var error;

    //var currentLocation = LocationData;
    var currentLocation;
    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      currentLocation = null;
    }

    lat = currentLocation.latitude;
    lon = currentLocation.longitude;
    //print latitude , longitude
    print('${lat},${lon}');

    final CameraPosition _here = CameraPosition(
      target: LatLng(lat, lon),
      zoom: 16,
    );

    //move to your location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_here));

    //get address by latitude & longitude
    final coordinates = new Coordinates(lat, lon);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    //print all address data
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

    //main addreess data
    var add = '${first.subAdminArea},${first.addressLine}';
    //add Marker to Map
    _onAddMarkerButtonPressed(lat, lon, add);
  }

  void _onAddMarkerButtonPressed(lat, lon, add) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("I'm here"),
        position: LatLng(
          lat,
          lon,
        ),
        infoWindow: InfoWindow(
          title: '${lat},${lon}',
          snippet: add,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
}
