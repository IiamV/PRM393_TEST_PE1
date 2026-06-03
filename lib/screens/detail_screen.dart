import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/post_provider.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<PostProvider, bool>(
      (provider) => provider.isFavorite(post.id),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            post.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Post #${post.id} by user ${post.userId}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 24),
          Text(
            post.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.read<PostProvider>().toggleFavorite(post),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(
              isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            ),
          ),
        ],
      ),
    );
  }
}
