package com.example.android_flutter_test

import android.content.Context
import com.google.gson.Gson
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class DatabaseHandler(context: Context, flutterEngine: FlutterEngine) {
    private val db = AppDatabase.getDatabase(context)
    private val postDao = db.postDao()
    private val gson = Gson()

    private val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.postviewer/db")

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "cachePosts" -> {
                    val json = call.argument<String>("postsJson")
                    if (json != null) {
                        val type = object : com.google.gson.reflect.TypeToken<List<PostEntity>>() {}.type
                        val posts: List<PostEntity> = gson.fromJson(json, type)
                        CoroutineScope(Dispatchers.IO).launch {
                            postDao.clearAll()
                            postDao.insertAll(posts)
                            withContext(Dispatchers.Main) {
                                result.success(true)
                            }
                        }
                    } else {
                        result.error("INVALID", "No posts data", null)
                    }
                }

                "getCachedPosts" -> {
                    CoroutineScope(Dispatchers.IO).launch {
                        val cachedPosts = postDao.getAll()
                        val jsonResult = gson.toJson(cachedPosts)
                        withContext(Dispatchers.Main) {
                            result.success(jsonResult)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}