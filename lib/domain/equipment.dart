class Equipment {
  late int id;
  String name;
  int count;
  String type;
  String description;

  Equipment(this.name, this.count, this.type, this.description, {int? id}) {
    this.id = id ?? 0;
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(json['name'], json['count'], json['type'], json['description'], id: json['id']);
  }

  Map<String, dynamic> toJson(){
    return <String, dynamic> {
      'id': id,
      'name': name,
      'count': count,
      'type': type,
      'description': description
    };
  }
}