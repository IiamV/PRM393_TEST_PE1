import 'package:flutter_test/flutter_test.dart';
import 'package:mini_news_reader/main.dart';
import 'package:mini_news_reader/providers/post_provider.dart';
import 'package:mini_news_reader/providers/theme_provider.dart';
import 'package:mini_news_reader/services/favorites_storage_service.dart';
import 'package:mini_news_reader/services/post_api_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows mini news reader home screen', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider(create: (_) => PostApiService()),
          Provider(create: (_) => FavoritesStorageService()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(
            create: (context) => PostProvider(
              apiService: context.read<PostApiService>(),
              storageService: context.read<FavoritesStorageService>(),
            ),
          ),
        ],
        child: const MiniNewsReaderApp(),
      ),
    );

    expect(find.text('Mini News Reader'), findsOneWidget);
    expect(find.text('Search posts'), findsOneWidget);
  });
}
