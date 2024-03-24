import '../models/generic_model.dart';

mixin IGenericRepository<T extends GenericModel> {
  List<T> getAll();
  Future<T?>? getById(int id);
  void update(T model, T newModel);
  void deleteById(int id);
  void delete(T model);
  void add(T model);
}
