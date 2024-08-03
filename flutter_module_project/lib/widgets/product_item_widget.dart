import 'package:flutter/material.dart';

import '../main.dart';
import '../models/product_model.dart';

class ProductItemWidget extends StatefulWidget {
  final ProductModel product;
  const ProductItemWidget({
    super.key,
    required this.product,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  void _saveRemoveProduct(int productId) {
    if (savedProducts.contains(productId)) {
      savedProducts.remove(productId);
    } else {
      savedProducts.add(productId);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final snackBar = SnackBar(
          content: Text(widget.product.title),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      leading: SizedBox(
        width: 60.0,
        height: 60.0,
        child: Image.network(
          widget.product.images.first,
          loadingBuilder: (context, child, loading) {
            if (loading == null) return child;
            return Container(
              width: 60.0,
              height: 60.0,
              color: Colors.grey.shade200,
            );
          },
        ),
      ),
      title: Text(
        widget.product.title,
        style: Theme.of(context).textTheme.titleMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.product.description,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: Icon(savedProducts.contains(widget.product.id)
            ? Icons.favorite
            : Icons.favorite_outline),
        onPressed: () {
          _saveRemoveProduct(widget.product.id);
        },
      ),
    );
  }
}
