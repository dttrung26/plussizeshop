import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show Product, WishListModel;

class HeartButton extends StatefulWidget {
  final Product product;
  final double size;
  final Color color;

  HeartButton({this.product, this.size, this.color});

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  @override
  Widget build(BuildContext context) {
    List<Product> wishlist = Provider.of<WishListModel>(context).getWishList();
    final isExist = wishlist.firstWhere((item) => item.id == widget.product.id,
        orElse: () => null);

    if (isExist == null) {
      return IconButton(
        onPressed: () {
          Provider.of<WishListModel>(context, listen: false)
              .addToWishlist(widget.product);
          setState(() {});
        },
        icon: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(FontAwesomeIcons.heart,
              color: Theme.of(context).accentColor.withOpacity(0.5),
              size: widget.size ?? 16.0),
        ),
      );
    }

    return IconButton(
      onPressed: () {
        Provider.of<WishListModel>(context, listen: false)
            .removeToWishlist(widget.product);
        setState(() {});
      },
      icon: CircleAvatar(
        backgroundColor: Colors.pink.withOpacity(0.1),
        child: Icon(FontAwesomeIcons.solidHeart,
            color: Colors.pink, size: widget.size ?? 16.0),
      ),
    );
  }
}
