import 'package:flutter/material.dart';
import 'package:flutter_module_project/services/product_service.dart';
import 'package:flutter_module_project/utils/app_extensions.dart';

import '../models/product_model.dart';
import '../widgets/product_item_widget.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _productService.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loading();
            }

            if (snapshot.hasError) {
              final Exception? error = snapshot.error as Exception?;

              return _error(error);
            }

            if (snapshot.hasData) {
              final products = snapshot.data ?? [];
              return _list(products);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16.0,
            width: 16.0,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Loading products...',
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }

  Widget _error(Exception? error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline),
          const SizedBox(height: 16.0),
          Text(
            error != null ? error!.getMessage : 'Something went wrong !',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: () => setState(() {}),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _list(List<ProductModel> products) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No Products available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _productService.getProducts().then((_) {
          const snackBar = SnackBar(
            content: Text('Products are up-to-date.'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }).onError((exception, __) {
          final error = exception as Exception?;
          final snackBar = SnackBar(
            content: Text(
              error != null ? error!.getMessage : 'Something went wrong !',
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      },
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductItemWidget(product: product);
        },
      ),
    );
  }
}
