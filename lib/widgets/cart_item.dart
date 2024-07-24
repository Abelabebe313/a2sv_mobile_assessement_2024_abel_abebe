import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatelessWidget with ChangeNotifier {
  final CartItem cartItem;
  final Function removeItem;

  CartItemWidget({super.key, required this.cartItem, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        removeItem(cartItem.id);
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 255, 229, 214),
            content: Text(
              "Item removed from cart!",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        );
        // after remove update the cartItem list in the provider
        notifyListeners();
      },
      child: Card(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CachedNetworkImage(
                  imageUrl: cartItem.image!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.orange[900],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Getting item image",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              cartItem.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            subtitle: Container(
              width: 50,
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.orange[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Total: \$${cartItem.price * cartItem.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            trailing: Text('${cartItem.quantity} x'),
          ),
        ),
      ),
    );
  }
}
