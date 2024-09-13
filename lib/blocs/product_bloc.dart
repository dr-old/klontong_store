import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

// Events
abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int page;
  final bool reload;
  final String category;

  FetchProducts(this.page, this.reload, {this.category = ""});
}

class AddProduct extends ProductEvent {
  final Product product;

  AddProduct(this.product);
}

class UpdateProduct extends ProductEvent {
  final String id;
  final Product product;

  UpdateProduct(this.id, this.product);
}

class DeleteProduct extends ProductEvent {
  final String id;

  DeleteProduct(this.id);
}

class SearchProducts extends ProductEvent {
  final String query;

  SearchProducts(this.query);
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;

  ProductLoaded(this.products, this.hasMore);
}

class ProductSearchLoaded extends ProductState {
  final List<Product> products;

  ProductSearchLoaded(this.products);
}

class ProductSuccess extends ProductState {
  final String message;

  ProductSuccess(this.message);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  int currentPage = 0;
  bool hasMore = true;
  List<Product> products = [];

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      if (event.page == 0) {
        currentPage = 0;
        products.clear();
        hasMore = true;
      } else {
        currentPage = event.page;
      }

      emit(ProductLoading());
      try {
        final newProducts = await repository.fetchProducts(
            currentPage, event.reload, event.category);
        if (currentPage == 0) {
          products = newProducts;
        } else {
          products.addAll(newProducts);
        }
        hasMore = newProducts.length == repository.pageSize;
        emit(ProductLoaded(products, hasMore));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<AddProduct>((event, emit) async {
      try {
        final message = await repository.addProduct(event.product);
        print(message);
        emit(ProductSuccess(message));
        add(FetchProducts(0, true));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<UpdateProduct>((event, emit) async {
      try {
        final message = await repository.updateProduct(event.id, event.product);
        print(message);
        emit(ProductSuccess(message));
        add(FetchProducts(0, true));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<DeleteProduct>((event, emit) async {
      try {
        final message = await repository.deleteProduct(event.id);
        emit(ProductSuccess(message));
        add(FetchProducts(0, true));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<SearchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final filteredProducts = repository.searchProducts(event.query);
        emit(ProductSearchLoaded(filteredProducts));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
