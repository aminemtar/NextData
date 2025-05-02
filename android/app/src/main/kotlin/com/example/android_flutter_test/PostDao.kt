package com.example.android_flutter_test

import androidx.room.*

@Dao
interface PostDao {
    @Query("SELECT * FROM posts")
    fun getAll(): List<PostEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insertAll(posts: List<PostEntity>)

    @Query("DELETE FROM posts")
    fun clearAll()
}