import 'package:avtar_demo/avtar/bloc/avtar_bloc.dart';
import 'package:avtar_demo/entity/avtar_model.dart';
import 'package:avtar_demo/widgets/avtar_details_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvtarCardWidget extends StatelessWidget {
  const AvtarCardWidget({super.key, required this.avatar, required this.favorites});
  final Avtar avatar;
  final List<String> favorites;

  @override
  Widget build(BuildContext context) {
        final avatarId = avatar.login?.uuid ?? '';
    final isFavorite = favorites.contains(avatarId);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AvatarDetailScreen(avatar: avatar),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  imageUrl: avatar.picture?.medium ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 40),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 40),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _commonText(
                      'Name',
                      '${avatar.name?.first ?? ''} ${avatar.name?.last ?? ''}',
                    ),
                    _commonText('Age', '${avatar.dob?.age ?? 'N/A'}'),
                    _commonText(
                      'Gender',
                      avatar.gender?.toUpperCase() ?? 'N/A',
                    ),
                    _commonText('Country', avatar.location?.country ?? 'N/A'),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<HomeBloc>().add(ToggleFavorite(avatarId));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _commonText(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$key: $value',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
