import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_store/screens/product/product_card.dart';
import '../../blocs/product_bloc.dart'; // Adjust your import path
import '../../models/product_model.dart';
import 'product_tile.dart';

class ProductListScreen extends StatefulWidget {
  final String category;

  const ProductListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingMore = false;
  bool _isSearching = false;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ProductBloc>()
        .add(FetchProducts(0, false, category: widget.category));
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<ProductBloc>().add(SearchProducts(query));
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<ProductBloc>().add(SearchProducts(''));
      }
    });
  }

  void _loadMore() {
    if (_isLoadingMore) return;

    final hasMore = context.read<ProductBloc>().hasMore;

    if (!hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final currentPage = context.read<ProductBloc>().currentPage;

    context
        .read<ProductBloc>()
        .add(FetchProducts(currentPage + 1, false, category: widget.category));

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left), // Use chevron back icon
          onPressed: () {
            context.read<ProductBloc>().add(FetchProducts(0, false));
            Navigator.of(context).pop();
          },
        ),
        title: _isSearching
            ? TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  hintText: 'Search...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).hintColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            : Text(
                widget.category != '' ? widget.category : 'Product List',
                style: Theme.of(context).textTheme.titleMedium,
              ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _toggleSearch,
            ),
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
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return _buildList(
                      context, state.products, state.hasMore.toString());
                } else if (state is ProductSearchLoaded) {
                  return _buildList(context, state.products, "null");
                } else if (state is ProductError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('No products available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<Product> products, String hasMore) {
    final filteredProducts = widget.category.isEmpty
        ? products
        : products
            .where((product) => product.categoryName == widget.category)
            .toList();

    // final searchProducts = _searchController.text.isEmpty
    //     ? filteredProducts
    //     : filteredProducts
    //         .where((product) => product.name == _searchController.text)
    //         .toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Text(
          'Data is not available',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (_isGridView) {
      return ListView.builder(
        controller: _scrollController,
        itemCount: hasMore == 'null'
            ? filteredProducts.length
            : filteredProducts.length + (hasMore == "true" ? 1 : 0),
        itemBuilder: (context, index) {
          if (hasMore != 'null') {
            if (index == filteredProducts.length) {
              return hasMore == "true"
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }
          }

          final product = filteredProducts[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: ProductTile(product: product),
          );
        },
      );
    } else {
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.65,
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ProductCard(product: product);
        },
      );
    }
  }
}
