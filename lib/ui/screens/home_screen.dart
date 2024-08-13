import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_bank/data/services/auth_firebase_services.dart';
import 'package:online_bank/logic/blocs/cart_bloc.dart';
import 'package:online_bank/ui/widgets/add_cart_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authFirebaseServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Carts Screen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              authFirebaseServices.logoutUser();
              setState(() {});
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),

      //

      body: BlocBuilder<CartBloc, CartState>(
        bloc: context.read<CartBloc>()..add(GetCartEvent()),
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorState) {
            return const Center(
              child: Text("Kartalar Yuklanishida Xatolik!!!"),
            );
          }
          if (state is LoadedState) {
            final cart = state.carts;

            return Column(
              children: [
                const SizedBox(height: 50),
                cart.isEmpty
                    ? const Center(
                        child: Text(
                          "Kartalar Mavjud Emas...",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 250,
                        child: PageView.builder(
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            final carts = cart[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  image: const DecorationImage(
                                    image:
                                        AssetImage("assets/images/back1.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                padding: const EdgeInsets.all(20),
                                height: 250,
                                width: 330,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "OILA BANKI",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      carts.cartName,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 65,
                                          child: Image.asset(
                                            "assets/images/card.png",
                                            height: 40,
                                            width: 55,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              carts.balance,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "So'm",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: 33,
                                          child: const Icon(
                                            Icons.wifi,
                                            size: 33,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      carts.cartNumber,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      carts.axpiryDate,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            );
          }
          return const Text("");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ZoomTapAnimation(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const CardInfoDialog(),
          );
        },
        child: Container(
          width: 300,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(244, 33, 54, 215),
          ),
          child: const Center(
            child: Text(
              "Add Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
