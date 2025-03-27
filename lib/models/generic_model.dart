abstract class GenericModel<T> {
  late String? id;

  GenericModel({this.id});

  T copyWith();

  Map<String, Object?>? toMap() {
    UnimplementedError(
        "The method toMap was not implemented in ${runtimeType.toString()} class!");
    return null;
  }
}
