class GenericModel {
  late int? id;

  GenericModel({this.id});

  GenericModel.fromMap(Map map) {
    id = map['id'];
  }

  Map<String, Object?>? toMap() {
    UnimplementedError(
        "The method toMap was not implemented in ${runtimeType.toString()} class!");
    return null;
  }
}
