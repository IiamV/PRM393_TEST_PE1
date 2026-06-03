import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/post_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini News Reader'),
        actions: [
          IconButton(
            tooltip: themeProvider.isDarkMode ? 'Use light mode' : 'Use dark mode',
            onPressed: themeProvider.toggleTheme,
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: postProvider.updateSearch,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search posts',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (postProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: MaterialBanner(
                padding: const EdgeInsets.all(12),
                leading: Icon(
                  postProvider.isOfflineFallback
                      ? Icons.cloud_off
                      : Icons.error_outline,
                ),
                content: Text(postProvider.errorMessage!),
                actions: [
                  TextButton(
                    onPressed: postProvider.fetchPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: postProvider.fetchPosts,
              child: _PostListBody(postProvider: postProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostListBody extends StatelessWidget {
  const _PostListBody({required this.postProvider});

  final PostProvider postProvider;

  @override
  Widget build(BuildContext context) {
    if (postProvider.isLoading && !postProvider.hasPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!postProvider.hasPosts) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          EmptyState(
            icon: Icons.article_outlined,
            title: 'No posts available',
            message: 'Pull down to refresh after checking your connection.',
          ),
        ],
      );
    }

    final posts = postProvider.posts;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Selector<PostProvider, bool>(
          selector: (_, provider) => provider.isFavorite(post.id),
          builder: (context, isFavorite, _) {
            return PostListItem(
              post: post,
              isFavorite: isFavorite,
            );
          },
        );
      },
    );
  }
}
