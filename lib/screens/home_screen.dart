import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_store/models/menu_model.dart';
import 'package:klontong_store/models/product_model.dart';
import 'package:klontong_store/repositories/menu_repository.dart';
import 'package:klontong_store/screens/product/product_card.dart';
import 'package:klontong_store/screens/product/product_form.dart';
import 'package:klontong_store/screens/product/product_tile.dart';
import '../../blocs/product_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isGridView = false;
  final MenuRepository menuRepository = MenuRepository();
  final FocusNode _searchFocusNode = FocusNode();
  bool _shouldFocus = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts(0, false));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_shouldFocus) {
        _searchFocusNode.requestFocus();
        print('object');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuItems = menuRepository.getMenuItems();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Klontong Store',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isGridView
                  ? Icons.grid_view_outlined
                  : Icons.view_agenda_outlined,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.indigo,
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProductForm(isEditing: false),
                    ),
                  );
                  setState(() {
                    _shouldFocus = true;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Search...',
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.black38,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            _buildTitle(context, 'Categories', ""),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 16.0),
                    ...menuItems.map((menuItem) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/productList',
                              arguments: {'category': menuItem.label},
                            );
                            setState(() {
                              _shouldFocus = true;
                            });
                          },
                          child: MenuCard(
                            imagePath: menuItem.imagePath ?? "",
                            label: menuItem.label,
                          ),
                        ),
                      );
                    }).toList()
                  ],
                ),
              ),
            ),
            _buildTitle(context, 'Recommend', "View All"),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  final List<Product> products = state.products;

                  if (_isGridView) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: products.map((product) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width) - 24,
                            child: ProductTile(product: product),
                          );
                        }).toList(),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: products.map((product) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 24,
                            child: ProductCard(product: product),
                          );
                        }).toList(),
                      ),
                    );
                  }
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No products available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String left, String right) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/productList',
                arguments: {'category': ''},
              );
              setState(() {
                _shouldFocus = true;
              });
            },
            child: Text(
              right,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const MenuCard({Key? key, required this.imagePath, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
