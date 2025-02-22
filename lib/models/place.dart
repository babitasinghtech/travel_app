class Place {
  String id;
  String name;
  String location;
  String description;

  Place({required this.id, required this.name, required this.location, required this.description});

  // Convert JSON to Object
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
    );
  }

  // Convert Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'description': description,
    };
  }
}
