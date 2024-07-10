import 'dart:async';
import 'dart:typed_data';

import 'package:air_listener/consts.dart';
import 'package:air_listener/services/mqtt_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial()) {
    on<PlayerEventLoad>(_onLoad);
    on<PlayerEventResume>(_onResume);
    on<PlayerEventPause>(_onPause);
    on<PlayerEventPlay>(_onPlay);
  }
  MQTTService? mqttService;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
      _streamSubscription;
  @override
  Future<void> close() {
    mqttService?.client.disconnect();
    _streamSubscription?.cancel();
    return super.close();
  }

  void _onLoad(event, Emitter<PlayerState> emit) async {
    emit(PlayerLoading());
    try {
      mqttService =
          MQTTService(MqttServerClient.withPort(brokerUrl, 'tv', brokerPort));
      await mqttService!.connect(user: 'tv', password: '20132013');
      mqttService!.subscribe('shairport/#');
      _streamSubscription = mqttService!.client.updates!.listen(_onUpdate);
    } catch (e) {
      emit(const PlayerError(message: 'error'));
    }
  }

  final Map<String, dynamic> _trackInfo = {};
  Uint8List _cover = Uint8List(0);

  void _onUpdate(List<MqttReceivedMessage<MqttMessage>> c) async {
    try {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = recMess.variableHeader!.topicName;
      print('Received message:$pt from topic: $topic');
      switch (topic) {
        case 'shairport/artist':
          _trackInfo['artist'] = pt;
          break;
        case 'shairport/album':
          _trackInfo['album'] = pt;
          break;
        case 'shairport/title':
          _trackInfo['title'] = pt;
          if (_trackInfo.length == 5) {
            final colorScheme = await ColorScheme.fromImageProvider(
                provider: MemoryImage(_cover));
            add(PlayerEventPlay(
              trackId: _trackInfo['track_id'] ?? "Unknown",
              colorScheme: colorScheme,
              albumName: _trackInfo['album'] ?? "Unknown",
              albumArtwork: _cover,
              artistName: _trackInfo['artist'] ?? "Unknown",
              trackName: _trackInfo['title'] ?? "Unknown",
              trackLength: '20000',
            ));
            _trackInfo.clear();
          }
          break;
        case 'shairport/duration':
          _trackInfo['duration'] = pt;
          break;
        case 'shairport/cover':
          _trackInfo['cover'] = Uint8List.view(recMess.payload.message.buffer,
              0, recMess.payload.message.lengthInBytes);
          _cover = _trackInfo['cover'];

          break;
        case 'shairport/track_id':
          _trackInfo['track_id'] = pt;
          break;
        case 'shairport/play_end':
          add(PlayerEventPause());
          break;
        case 'shairport/play_resume':
          if (_trackInfo.length == 5) {
            final colorScheme = await ColorScheme.fromImageProvider(
                provider: MemoryImage(_cover));
            add(PlayerEventPlay(
              trackId: _trackInfo['track_id'],
              albumName: _trackInfo['album'],
              albumArtwork: _cover,
              colorScheme: colorScheme,
              artistName: _trackInfo['artist'],
              trackName: _trackInfo['title'],
              trackLength: '20000',
            ));
            _trackInfo.clear();
          }
          break;
      }
    } catch (e) {
      debugPrint('error on Update: ${e.toString()}');
    }
  }

  void _onResume(PlayerEventResume event, Emitter<PlayerState> emit) async {
    final state = this.state as PlayerPaused;
    emit(PlayerPlaying(
      trackId: state.trackId,
      albumName: state.albumName,
      artistName: state.artistName,
      colorScheme: state.colorScheme,
      trackName: state.trackName,
      trackLength: state.trackLength,
      position: state.position,
      volume: state.volume,
      albumArtwork: state.albumArtwork,
    ));
  }

  void _onPlay(PlayerEventPlay event, Emitter<PlayerState> emit) async {
    emit(PlayerPlaying(
      trackId: event.trackId,
      albumName: event.albumName,
      artistName: event.artistName,
      trackName: event.trackName,
      trackLength: Duration(seconds: int.parse(event.trackLength)),
      position: Duration.zero,
      colorScheme: event.colorScheme,
      volume: 1.0,
      albumArtwork: event.albumArtwork,
    ));
  }

  void _onPause(PlayerEventPause event, Emitter<PlayerState> emit) {
    final state = this.state as PlayerPlaying;
    emit(PlayerPaused(
      trackId: state.trackId,
      albumName: state.albumName,
      artistName: state.artistName,
      colorScheme: state.colorScheme,
      trackName: state.trackName,
      trackLength: state.trackLength,
      albumArtwork: state.albumArtwork,
      position: state.position,
      volume: state.volume,
    ));
  }
}
