import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_store/blocs/category_bloc.dart';
import 'package:klontong_store/models/product_model.dart';
import 'package:klontong_store/repositories/category_respository.dart';
import 'package:klontong_store/screens/home_screen.dart';
import 'package:klontong_store/screens/product/product_detail_screen.dart';
import 'package:klontong_store/screens/product/product_list_screen.dart';
import 'package:klontong_store/utils/theme.dart';
import 'blocs/product_bloc.dart';
import 'repositories/product_repository.dart';

void main() {
  Bloc.observer = const AppBlocObserver(); // Set up the custom Bloc observer

  final ProductRepository productRepository = ProductRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  runApp(App(
    productRepository: productRepository,
    categoryRepository: categoryRepository,
  ));
}

/// Custom [BlocObserver] to monitor all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

/// The root [App] widget where the [ProductBloc] is provided.
class App extends StatelessWidget {
  final ProductRepository productRepository;
  final CategoryRepository categoryRepository;

  const App(
      {super.key,
      required this.productRepository,
      required this.categoryRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) =>
              ProductBloc(productRepository)..add(FetchProducts(0, false)),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(categoryRepository)
            ..add(FetchCategories(0, false, all: true)),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            final arguments = settings.arguments as Map<String, dynamic>?;

            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );
              case '/productList':
                final category = arguments?['category'] ?? '';
                return MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: category),
                );
              case '/productDetail':
                final product = arguments?['product'] as Product;
                return MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                );
            }
          },
        );
      },
    );
  }
}
