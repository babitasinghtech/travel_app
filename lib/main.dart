import 'package:flutter/material.dart';
import 'package:travelapp/Services/api_services.dart';
import 'package:travelapp/pages/login.dart';
import 'models/place.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Travel Places",
      home: Login(),
    );
  }
}

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Future<List<Place>> places;

  @override
  void initState() {
    super.initState();
    places = ApiService.fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Travel Places")),
      body: FutureBuilder<List<Place>>(
        future: places,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No places found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var place = snapshot.data![index];
              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.location),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ApiService.deletePlace(place.id);
                    setState(() {
                      places = ApiService.fetchPlaces();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
