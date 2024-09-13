import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/category_model.dart';
import '../repositories/category_respository.dart';

// Event
abstract class CategoryEvent {}

class FetchCategories extends CategoryEvent {
  final int page;
  final bool reload;
  final bool? all;

  FetchCategories(this.page, this.reload, {this.all = false});
}

class AddCategory extends CategoryEvent {
  final Category category;

  AddCategory(this.category);
}

class UpdateCategory extends CategoryEvent {
  final String id;
  final Category category;

  UpdateCategory(this.id, this.category);
}

class DeleteCategory extends CategoryEvent {
  final String id;

  DeleteCategory(this.id);
}

class SearchCategories extends CategoryEvent {
  final String query;

  SearchCategories(this.query);
}

// State
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final bool hasMore;

  CategoryLoaded(this.categories, this.hasMore);
}

class CategorySearchLoaded extends CategoryState {
  final List<Category> categories;

  CategorySearchLoaded(this.categories);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;
  int currentPage = 0;
  bool hasMore = true;
  List<Category> categories = [];
  List<Category> allCategory = [];

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      if (event.page == 0) {
        currentPage = 0;
        categories.clear();
        hasMore = true;
      } else {
        currentPage = event.page;
      }

      emit(CategoryLoading());
      try {
        final newCategories = await repository.fetchCategories(
            currentPage, event.reload, event.all);
        if (currentPage == 0) {
          categories = newCategories;
        } else {
          categories.addAll(newCategories);
        }
        hasMore = newCategories.length == repository.pageSize;
        emit(CategoryLoaded(categories, hasMore));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategory>((event, emit) async {
      try {
        await repository.addCategory(event.category);
        add(FetchCategories(0, true));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<UpdateCategory>((event, emit) async {
      try {
        await repository.updateCategory(event.id, event.category);
        add(FetchCategories(0, true));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategory>((event, emit) async {
      try {
        await repository.deleteCategory(event.id);
        add(FetchCategories(0, true));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<SearchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final filteredCategories = repository.searchCategories(event.query);
        emit(CategorySearchLoaded(filteredCategories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
