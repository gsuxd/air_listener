part of 'player_bloc.dart';

@immutable
sealed class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object> get props => [];
}

final class PlayerInitial extends PlayerState {}

final class PlayerLoading extends PlayerState {}

final class PlayerPlaying extends PlayerState {
  final String trackId;
  final Uint8List albumArtwork;
  final String albumName;
  final String artistName;
  final String trackName;
  final Duration trackLength;
  final ColorScheme colorScheme;
  final Duration position;
  final double volume;

  const PlayerPlaying({
    required this.trackId,
    required this.albumName,
    required this.albumArtwork,
    required this.artistName,
    required this.trackName,
    required this.colorScheme,
    required this.trackLength,
    required this.position,
    required this.volume,
  });

  @override
  List<Object> get props => [
        trackId,
        albumName,
        artistName,
        trackName,
        trackLength,
        position,
        volume
      ];
}

final class PlayerPaused extends PlayerPlaying {
  const PlayerPaused({
    required super.trackId,
    required super.albumName,
    required super.artistName,
    required super.trackName,
    required super.trackLength,
    required super.colorScheme,
    required super.albumArtwork,
    required super.position,
    required super.volume,
  });
}

final class PlayerStopped extends PlayerState {}

final class PlayerError extends PlayerState {
  final String message;

  const PlayerError({required this.message});

  @override
  List<Object> get props => [message];
}

final class PlayerFinished extends PlayerState {}
