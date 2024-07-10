part of 'player_bloc.dart';

@immutable
sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

final class PlayerEventLoad extends PlayerEvent {}

final class PlayerEventPlay extends PlayerEvent {
  final String trackId;
  final String albumName;
  final String artistName;
  final String trackName;
  final ColorScheme colorScheme;
  final Uint8List albumArtwork;
  final String trackLength;

  const PlayerEventPlay({
    required this.trackId,
    required this.albumName,
    required this.artistName,
    required this.colorScheme,
    required this.albumArtwork,
    required this.trackName,
    required this.trackLength,
  });

  @override
  List<Object> get props =>
      [trackId, albumName, artistName, trackName, trackLength];
}

final class PlayerEventPause extends PlayerEvent {}

final class PlayerEventResume extends PlayerEvent {}

final class PlayerEventStop extends PlayerEvent {}

final class PlayerEventSeek extends PlayerEvent {
  final Duration position;

  const PlayerEventSeek({required this.position});

  @override
  List<Object> get props => [position];
}

final class PlayerEventVolume extends PlayerEvent {
  final double volume;

  const PlayerEventVolume({required this.volume});

  @override
  List<Object> get props => [volume];
}
