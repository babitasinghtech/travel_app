import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class SingleCity extends StatefulWidget {
  final Map cityData;
  // ignore: use_super_parameters
  const SingleCity({Key? key, required this.cityData}) : super(key: key);

  // ignore: empty_constructor_bodies
  @override
  State<SingleCity> createState() => _SingleCityState();
}

class _SingleCityState extends State<SingleCity> {
  @override

  // ignore: override_on_non_overriding_mem
  //
  // ber
  // ignore: override_on_non_overriding_member
  final Map<String, Marker> _markers = {};

  BitmapDescriptor? pinLocationIcon;

  void setCustomMapPin() async {
    // ignore: deprecated_member_use
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/markericon.png',
    );
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();

    setState(() {
      final marker = Marker(
        icon: pinLocationIcon!,
        markerId: MarkerId(widget.cityData['name']),
        position: LatLng(widget.cityData['lat'], widget.cityData['lng']),
        infoWindow: InfoWindow(
            title: widget.cityData['name'],
            snippet: widget.cityData['address'],
            onTap: () {
              print("${widget.cityData['lat']}, ${widget.cityData['lng']}");
            }),
        onTap: () {
          print("Clicked on marker");
        },
      );
      print("${widget.cityData['lat']}, ${widget.cityData['lng']}");
      _markers[widget.cityData['name']] = marker;
    });
  }

  launchMap(lat, long) {
    MapsLauncher.launchCoordinates(lat, long); //for showing the map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About ${widget.cityData['name']}')),
      body: Column(
        children: [
          Card(
            elevation: 5,
            child: Column(
              children: [
                Image.network(
                  widget.cityData['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.cityData['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        launchMap(
                            widget.cityData['lat'], widget.cityData['lng']);
                      },
                      child: const Text("Direction"),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.cityData['lat'], widget.cityData['lng']),
                zoom: 7,
              ),
              markers: _markers.values.toSet(),
            ),
          )
        ],
      ),
    );
  }
}
