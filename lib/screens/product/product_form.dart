import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:klontong_store/models/menu_model.dart';
import 'package:klontong_store/repositories/menu_repository.dart';
import 'package:klontong_store/utils/helpers.dart';
import '../../blocs/product_bloc.dart';
import '../../blocs/category_bloc.dart';
import '../../models/product_model.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  const ProductForm({Key? key, this.product, required this.isEditing})
      : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _skuController;
  late TextEditingController _weightController;
  late TextEditingController _widthController;
  late TextEditingController _lengthController;
  late TextEditingController _heightController;
  late TextEditingController _imageController;
  MenuItem? _selectedCategory;
  final MenuRepository menuRepository = MenuRepository();

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.isEditing ? widget.product?.name : '',
    );
    _descriptionController = TextEditingController(
      text: widget.isEditing ? widget.product?.description : '',
    );
    _priceController = TextEditingController(
      text: widget.isEditing ? widget.product?.price.toString() : '',
    );
    _skuController = TextEditingController(
      text: widget.isEditing ? widget.product?.sku : generateSKU(''),
    );
    _weightController = TextEditingController(
      text: widget.isEditing ? widget.product?.weight.toString() : '',
    );
    _widthController = TextEditingController(
      text: widget.isEditing ? widget.product?.width.toString() : '',
    );
    _lengthController = TextEditingController(
      text: widget.isEditing ? widget.product?.length.toString() : '',
    );
    _heightController = TextEditingController(
      text: widget.isEditing ? widget.product?.height.toString() : '',
    );
    _imageController = TextEditingController(
      text: widget.isEditing ? widget.product?.image : '',
    );

    // Pre-select the category if editing
    _selectedCategory = widget.isEditing
        ? MenuItem(
            id: widget.product?.categoryId ?? "",
            label: widget.product?.categoryName ?? "")
        : null;

    context.read<CategoryBloc>().add(FetchCategories(0, false, all: true));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _skuController.dispose();
    _weightController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final product = Product(
        name: _nameController.text,
        description: _descriptionController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        sku: _skuController.text,
        categoryName: _selectedCategory?.label ?? '',
        categoryId: _selectedCategory?.id ?? '',
        weight: int.tryParse(_weightController.text) ?? 0,
        width: int.tryParse(_widthController.text) ?? 0,
        length: int.tryParse(_lengthController.text) ?? 0,
        height: int.tryParse(_heightController.text) ?? 0,
        image: _imageController.text,
      );

      if (widget.isEditing) {
        context
            .read<ProductBloc>()
            .add(UpdateProduct(widget.product!.id ?? "", product));
      } else {
        context.read<ProductBloc>().add(AddProduct(product));
      }
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItem> menuItems = menuRepository.getMenuItems();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.isEditing ? 'Edit Product' : 'Add Product',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccess) {
            if (widget.isEditing) {
              Navigator.of(context).popAndPushNamed('/');
            } else {
              Navigator.of(context).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'Enter product name',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownSearch<MenuItem>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Category",
                        hintText: "Select Category",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black12,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    items: menuItems,
                    selectedItem: _selectedCategory,
                    itemAsString: (category) => category.label,
                    onChanged: (MenuItem? category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter description',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter price',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            suffixText: 'g',
                            hintText: 'Enter weight',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _lengthController,
                          decoration: InputDecoration(
                            labelText: 'Length',
                            suffixText: 'cm',
                            hintText: 'Enter length',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter a valid length';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _widthController,
                          decoration: InputDecoration(
                            labelText: 'Width',
                            suffixText: 'cm',
                            hintText: 'Enter width',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter a valid width';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: InputDecoration(
                            labelText: 'Height',
                            suffixText: 'cm',
                            hintText: 'Enter height',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black12,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || int.tryParse(value) == null) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _imageController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'Enter image URL',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _cancel,
                        child: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor:
                              Colors.white, // Text color for Cancel
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(widget.isEditing ? 'Update' : 'Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor:
                              Colors.white, // Text color for Submit
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
