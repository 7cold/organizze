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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['archived'] = this.archived;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['default'] = this.defaultAccount;
    data['type'] = this.type;
    return data;
  }
}
