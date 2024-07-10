import 'package:air_listener/bloc/player_bloc.dart';
import 'package:air_listener/components/player_view.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      primaryColors: context.select<PlayerBloc, List<Color>>((value) =>
          (value.state is PlayerPlaying || value.state is PlayerPaused)
              ? [
                  (value.state as PlayerPlaying).colorScheme.primary,
                  (value.state as PlayerPlaying)
                      .colorScheme
                      .primary
                      .withOpacity(0.9)
                ]
              : [Colors.purple, Colors.deepPurple]),
      secondaryColors: context.select<PlayerBloc, List<Color>>((value) =>
          (value.state is PlayerPlaying || value.state is PlayerPaused)
              ? [
                  (value.state as PlayerPlaying).colorScheme.secondary,
                  (value.state as PlayerPlaying)
                      .colorScheme
                      .secondary
                      .withOpacity(0.9)
                ]
              : [Colors.deepPurple, Colors.purple]),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const PlayerView(),
            ),
          )),
    );
  }
}
