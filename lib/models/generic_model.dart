class GenericModel {
  late int? id;
  late String? tableName;

  GenericModel.fromMap(Map map) {
    id = map['id'];
  }

  GenericModel({this.id, this.tableName});

  Map<String, Object?>? toMap() {
    UnimplementedError(
        "The method toMap was not implemented in ${runtimeType.toString()} class!");
    return null;
  }
}
