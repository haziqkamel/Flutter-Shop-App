import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop_app/models/product.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  // var urlPattern =
  //     r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  // var result = new RegExp(urlPattern, caseSensitive: false).firstMatch('https://www.google.com');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // ModalRoute.of(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('https') &&
              !_imageUrlController.text.startsWith('http')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate(); //validate the form val
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String initialUrl =
        "https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png";

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                  icon: Icon(Icons.title),
                  border: UnderlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Please provide the title';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                  icon: Icon(Icons.price_change),
                  border: UnderlineInputBorder(),
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Please provide the price';
                  }
                  if (double.tryParse(v) == null) {
                    return 'Invalid price';
                  }
                  if (double.parse(v) <= 0) {
                    return 'Price cannot be 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                  icon: Icon(Icons.description),
                  border: UnderlineInputBorder(),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (v.length < 3) {
                    return 'Description should be at least 3 chars';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? FittedBox(child: Image.network(initialUrl))
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      // initialValue: _initValues[initialUrl],
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (v) {
                        if (v.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!v.startsWith('http') || !v.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!v.endsWith('.png') &&
                            !v.endsWith('.jpg') &&
                            !v.endsWith('.jpeg')) {
                          return 'Invalid image URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
