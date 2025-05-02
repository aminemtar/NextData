import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Models/post.dart';
import '../Models/user.dart';

class PostViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  Map<int, User> _usersById = {};
  bool _isLoading = true;

  static const platform = MethodChannel('com.example.postviewer/db');

  List<Post> get posts => _filteredPosts;
  bool get isLoading => _isLoading;

  PostViewModel() {
    fetchPostsAndUsers();
  }

  Future<void> fetchPostsAndUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final postResponse = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      final userResponse = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (postResponse.statusCode == 200 && userResponse.statusCode == 200) {
        final postList =
            (jsonDecode(postResponse.body) as List)
                .map((json) => Post.fromJson(json))
                .toList();

        final userList =
            (jsonDecode(userResponse.body) as List)
                .map((json) => User.fromJson(json))
                .toList();

        _usersById = {for (var user in userList) user.id: user};
        _posts = postList;
        _filteredPosts = postList;

        final postsJson = jsonEncode(postList.map((p) => p.toJson()).toList());
        await platform.invokeMethod('cachePosts', {"postsJson": postsJson});
      } else {
        await _loadFromLocal();
      }
    } catch (e) {
      await _loadFromLocal();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromLocal() async {
    try {
      final String jsonString = await platform.invokeMethod('getCachedPosts');
      print("Loaded from local DB: $jsonString");

      final List<dynamic> jsonList = jsonDecode(jsonString);
      _posts = jsonList.map((json) => Post.fromJson(json)).toList();
      _filteredPosts = _posts;
    } catch (e) {
      print('Error loading from local DB: $e');
    }
  }

  String getUserName(int userId) {
    print(_usersById[userId]?.name);
    return _usersById[userId]?.name ?? 'Leane Graham';
  }

  void filterPosts(String query) {
    if (query.isEmpty) {
      _filteredPosts = _posts;
    } else {
      _filteredPosts =
          _posts.where((post) {
            return post.title.toLowerCase().contains(query.toLowerCase()) ||
                post.body.toLowerCase().contains(query.toLowerCase());
          }).toList();
    }
    notifyListeners();
  }

  Future<User?> fetchUserById(int userId) async {
    if (_usersById.containsKey(userId)) {
      return _usersById[userId];
    }

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(jsonDecode(response.body));
        _usersById[userId] = user;
        return user;
      }
    } catch (e) {
      debugPrint('Error fetching user $userId: $e');
    }

    return null;
  }
}
