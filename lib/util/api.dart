import 'dart:convert';

import 'package:fluttube/models/video.dart';
import 'package:fluttube/util/config.dart';
import 'package:http/http.dart' as http;

const API_KEY = API_KEY_SECRET;

class Api {
  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10');

    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http.get(
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken');

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _nextToken = decoded['nextPageToken'];

      return decoded['items']
          .map<Video>((item) => Video.fromJson(item))
          .toList();
    } else {
      throw Exception('Erro ao carregar os vídeos');
    }
  }
}
