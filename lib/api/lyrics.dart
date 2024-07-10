import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:lrc/lrc.dart';

abstract class LyricsAPI {
  Future<List<LrcLine>> getLyrics(
      {required String artist,
      required String title,
      required Duration duration,
      required String album}) async {
    try {
      final res = await GetIt.I
          .get<Dio>()
          .get("https://lrclib.net/api/", queryParameters: {
        "artist": artist,
        "title": title,
        "duration": duration.inSeconds,
        "album": album,
      });

      final parsed = (res.data['syncedLyrics'] as String).toLrc();
      return parsed.lyrics;
    } catch (e) {
      return [];
    }
  }
}
