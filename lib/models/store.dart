class Store {
  final String id;
  final String name;

  final Map<String, dynamic> location;

  Store({
    required this.id,
    required this.name,
    required this.location,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'],
      name: json['name'],
      location: json['location'],
    );
  }
}
