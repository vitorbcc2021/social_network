abstract class GenericModel {
  late String? id;

  GenericModel({this.id});

  Map<String, Object?>? toMap() {
    UnimplementedError(
        "The method toMap was not implemented in ${runtimeType.toString()} class!");
    return null;
  }
}
