import 'dart:convert';
import 'package:android_flutter_test/Models/post.dart';
import 'package:flutter/services.dart';

class NativeDatabaseService {
  static const _channel = MethodChannel('com.example.postviewer/db');

  static Future<void> cachePosts(List<Post> posts) async {
    final jsonPosts = jsonEncode(posts.map((e) => e.toJson()).toList());
    await _channel.invokeMethod('cachePosts', {'postsJson': jsonPosts});
  }

  static Future<List<Post>> getCachedPosts() async {
    final json = await _channel.invokeMethod('getCachedPosts');
    final List decoded = jsonDecode(json);
    return decoded.map((e) => Post.fromJson(e)).toList();
  }
}
