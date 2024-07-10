import 'package:air_listener/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'bloc/player_bloc.dart';

final playerBloc = PlayerBloc();

void main() {
  GetIt.I.registerSingleton<PlayerBloc>(playerBloc);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      restorationScopeId: 'app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider.value(
          value: playerBloc..add(PlayerEventLoad()),
          child: const PlayerScreen()),
    );
  }
}
