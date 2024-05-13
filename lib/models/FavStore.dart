class FavStore {
  String id;
  String name;
  double distance;

  FavStore({
    required this.id,
    required this.name,
    required this.distance,
  });

  factory FavStore.fromJson(Map<String, dynamic> json) => FavStore(
        id: json["_id"],
        name: json["name"],
        distance: json["distance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "distance": distance,
      };
}
