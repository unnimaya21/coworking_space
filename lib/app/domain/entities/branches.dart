class CoworkingBranch {
  final String id;
  final String name;
  final String location;
  final String city;
  final double pricePerHour;
  final String description;
  final List<String> images;
  final List<String> amenities;
  final Map<String, String> operatingHours;
  final Map<String, double> coordinates;

  CoworkingBranch({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.pricePerHour,
    required this.description,
    required this.images,
    required this.amenities,
    required this.operatingHours,
    required this.coordinates,
  });

  factory CoworkingBranch.fromJson(Map<String, dynamic> json) {
    return CoworkingBranch(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      city: json['city'],
      pricePerHour: json['pricePerHour'],
      description: json['description'],
      images: List<String>.from(json['images']),
      amenities: List<String>.from(json['amenities']),
      operatingHours: Map<String, String>.from(json['operatingHours']),
      coordinates: Map<String, double>.from(json['coordinates']),
    );
  }
}
