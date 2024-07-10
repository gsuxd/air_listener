import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/player_bloc.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerPlaying || state is PlayerPaused) {
          return _View(state as PlayerPlaying);
        }
        if (state is PlayerError ||
            state is PlayerInitial ||
            state is PlayerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PlayerStopped || state is PlayerFinished) {
          return const Center(
            child: Text('Stopped'),
          );
        }
        return const Center(
          child: Text('Unknown state'),
        );
      },
    );
  }
}

class _View extends StatelessWidget {
  const _View(this.state);
  final PlayerPlaying state;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
                child: Image.memory(
                  state.albumArtwork,
                  height: MediaQuery.of(context).size.width * 0.25,
                ),
              ),
              if (state is PlayerPaused)
                Positioned.fill(
                  child: const Center(
                    child: Icon(
                      Icons.pause,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(state.position.toString()),
              //     const Spacer(),
              //     Text(state.trackLength.toString()),
              //   ],
              // ),
              // const SizedBox(height: 2),
              // LinearProgressIndicator(
              //   value: state.position.inMilliseconds /
              //       state.trackLength.inMilliseconds,
              // ),
              const SizedBox(height: 10),
              Text(
                state.trackName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: state.colorScheme.onPrimary),
              ),
              Text(
                "${state.artistName} - ${state.albumName}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: state.colorScheme.onPrimary),
              ),
            ],
          )
        ]));
  }
}
