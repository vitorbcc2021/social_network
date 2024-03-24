import 'package:social_network/models/generic_model.dart';
import 'package:social_network/repositories/i_generic_repository.dart';
import 'package:flutter/material.dart';

class GenericRepository<T extends GenericModel> with IGenericRepository<T> {
  List<T> models = [];

  @override
  void add(T model) {
    models.add(model);
  }

  @override
  void delete(T model) {
    models.remove(model);
  }

  @override
  void deleteById(int id) {
    models.removeWhere((model) => model.id == id);
  }

  @override
  List<T> getAll() {
    return models;
  }

  @override
  Future<T?>? getById(int id) {
    return null;
  }

  @override
  void update(T model, T newModel) {
    model = newModel;
  }
}
