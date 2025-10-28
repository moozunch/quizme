import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'provider/app_state.dart';
import 'screens/home.dart';
import 'screens/create_quiz.dart';
import 'screens/join_quiz.dart';
import 'screens/quiz_detail.dart';
import 'screens/quiz_play.dart';

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
          return QuizPlayScreen(quizId: id);
        }),
      ],
    );

    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp.router(
        title: 'QuizMe',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
