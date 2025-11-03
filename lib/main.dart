import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'provider/app_state.dart';
import 'screens/home.dart';
import 'screens/create_quiz.dart';
import 'screens/join_quiz.dart';
import 'screens/quiz_detail.dart';
import 'screens/quiz_play.dart';
import 'screens/quiz_created.dart';
import 'screens/quiz_result.dart';
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  runApp(MyApp(appState: appState));
}

class MyApp extends StatelessWidget {
  final AppState appState;
  MyApp({super.key, AppState? appState}) : appState = appState ?? AppState();
  

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/create', builder: (context, state) => const CreateQuizScreen()),
        GoRoute(path: '/join', builder: (context, state) => const JoinQuizScreen()),
        GoRoute(path: '/quiz/:id', builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuizDetailScreen(quizId: id);
        }),
        GoRoute(path: '/quiz/:id/play', builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.extra is String ? state.extra as String : null;
          return QuizPlayScreen(quizId: id, participantName: name);
        }),
        GoRoute(path: '/quiz/:id/created', builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuizCreatedScreen(quizId: id);
        }),
          
        GoRoute(path: '/quiz/:id/result', builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extras = state.extra as Map<String, dynamic>?;
          final score = (extras?['score'] as int?) ?? 0;
          final total = (extras?['total'] as int?) ?? 0;
          final name = extras?['name'] as String?;
          return QuizResultScreen(quizId: id, score: score, total: total, participantName: name);
        }),
      ],
    );

    return ChangeNotifierProvider.value(
      value: appState,
      child: Consumer<AppState>(
        builder: (context, state, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'QuizMe',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: state.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
