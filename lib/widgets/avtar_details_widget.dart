import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:avtar_demo/entity/avtar_model.dart';

class AvatarDetailScreen extends StatelessWidget {
  final Avtar avatar;

  const AvatarDetailScreen({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${avatar.name?.first ?? ''} ${avatar.name?.last ?? ''}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: avatar.picture?.large ?? '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 100),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 100),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Full Name',
                      '${avatar.name?.title ?? ''} ${avatar.name?.first ?? ''} ${avatar.name?.last ?? ''}',
                    ),
                    _buildDetailRow(
                      'Gender',
                      avatar.gender?.toUpperCase() ?? 'N/A',
                    ),
                    _buildDetailRow('Age', '${avatar.dob?.age ?? 'N/A'}'),
                    _buildDetailRow(
                      'Date of Birth',
                      _formatDate(avatar.dob?.date),
                    ),
                    _buildDetailRow('Email', avatar.email ?? 'N/A'),
                    _buildDetailRow('Phone', avatar.phone ?? 'N/A'),
                    _buildDetailRow('Cell', avatar.cell ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Country',
                      avatar.location?.country ?? 'N/A',
                    ),
                    _buildDetailRow('State', avatar.location?.state ?? 'N/A'),
                    _buildDetailRow('City', avatar.location?.city ?? 'N/A'),
                    _buildDetailRow(
                      'Street',
                      '${avatar.location?.street?.number ?? ''} ${avatar.location?.street?.name ?? ''}',
                    ),
                    _buildDetailRow(
                      'Postcode',
                      '${avatar.location?.postcode ?? 'N/A'}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'N/A';
    }
  }
}
