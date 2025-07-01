import 'package:avtar_demo/avtar/bloc/avtar_bloc.dart';
import 'package:avtar_demo/avtar/view/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'avtar/view/avtar_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomeBloc()
                ..add(LoadFavorites())
                ..add(FetchAvatars()),
      child: MaterialApp(
        routes: {
          '/': (context) => const AvtarScreen(),
          '/favorites': (context) => const FavoritesScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
