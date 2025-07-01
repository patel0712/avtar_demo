import 'package:avtar_demo/avtar/bloc/avtar_bloc.dart';
import 'package:avtar_demo/entity/avtar_model.dart';
import 'package:avtar_demo/widgets/avtar_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<HomeBloc, AvatarState>(
        builder: (context, state) {
          final favoriteAvatars = _getFavoriteAvatars(state);

          if (state.status == AvtarStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (favoriteAvatars.isEmpty) {
            return _buildEmptyFavorites();
          }

          return _buildFavoritesList(favoriteAvatars, state.favorites);
        },
      ),
    );
  }

  List<Avtar> _getFavoriteAvatars(AvatarState state) {
    return state.avatars
        .where((avatar) => state.favorites.contains(avatar.login?.uuid ?? ''))
        .toList();
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add avatars to your favorites by tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.explore),
            label: const Text('Explore Avatars'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    List<Avtar> favoriteAvatars,
    List<String> favorites,
  ) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: favoriteAvatars.length,
        itemBuilder: (context, index) {
          final avatar = favoriteAvatars[index];
          return AvtarCardWidget(avatar: avatar, favorites: favorites);
        },
      ),
    );
  }
}
