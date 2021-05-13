class Accouts {
  int id;
  String name;
  String description;
  bool archived;
  String createdAt;
  String updatedAt;
  bool defaultAccount;
  String type;

  Accouts(
      {this.id,
      this.name,
      this.description,
      this.archived,
      this.createdAt,
      this.updatedAt,
      this.defaultAccount,
      this.type});

  Accouts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    archived = json['archived'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    defaultAccount = json['default'];
    type = json['type'];
  }
}
