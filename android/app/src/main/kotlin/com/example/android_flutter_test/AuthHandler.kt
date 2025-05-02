package com.example.android_flutter_test
import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class AuthHandler(private val context: Context, flutterEngine: FlutterEngine) {
    private val channel = "com.example.postviewer/auth"
    private val auth: FirebaseAuth = Firebase.auth

    init {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "login" -> handleLogin(call, result)
                "signup" -> handleSignup(call, result)
                "logout" -> handleLogout(result)
                "getCurrentUser" -> getCurrentUser(result)
                "getToken" -> getToken(result)
                "clearToken" -> clearToken()
                else -> result.notImplemented()
            }
        }
    }

    private fun handleLogin(call: MethodCall, result: MethodChannel.Result) {
        val email = call.argument<String>("email")
        val password = call.argument<String>("password")

        if (email.isNullOrEmpty() || password.isNullOrEmpty()) {
            result.error("INVALID_INPUT", "Email and password cannot be empty", null)
            return
        }

        auth.signInWithEmailAndPassword(email, password)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    auth.currentUser?.getIdToken(true)?.addOnSuccessListener { resultToken ->
                        val token = resultToken.token
                        if (token != null) {
                            print("token" +token)
                            saveToken(token)
                            result.success(true)
                        } else {
                            result.error("TOKEN_ERROR", "Token is null", null)
                        }
                    }?.addOnFailureListener {
                        result.error("TOKEN_FETCH_FAILED", it.message, null)
                    }
                } else {
                    result.error("LOGIN_FAILED", task.exception?.message ?: "Login failed", null)
                }
            }
    }
    private fun saveToken(token: String) {
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        val sharedPrefs = EncryptedSharedPreferences.create(
            context,
            "auth_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        sharedPrefs.edit().putString("auth_token", token).apply()
    }
    private fun handleSignup(call: MethodCall, result: MethodChannel.Result) {
        val email = call.argument<String>("email")
        val password = call.argument<String>("password")

        if (email.isNullOrEmpty() || password.isNullOrEmpty()) {
            result.error("INVALID_INPUT", "Email and password cannot be empty", null)
            return
        }

        if (password.length < 6) {
            result.error("WEAK_PASSWORD", "Password must be at least 6 characters", null)
            return
        }

        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    result.success(true)
                } else {
                    result.error("SIGNUP_FAILED", task.exception?.message ?: "Signup failed", null)
                }
            }
    }

    private fun handleLogout(result: MethodChannel.Result) {
        auth.signOut()
        result.success(true)
    }

    private fun getCurrentUser(result: MethodChannel.Result) {
        val user = auth.currentUser
        if (user != null) {
            result.success(mapOf(
                "email" to user.email,
                "uid" to user.uid,
                "isEmailVerified" to user.isEmailVerified
            ))
        } else {
            result.success(null)
        }
    }
    private fun getToken(result: MethodChannel.Result) {
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        val sharedPrefs = EncryptedSharedPreferences.create(
            context,
            "auth_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        val token = sharedPrefs.getString("auth_token", null)
        result.success(token)
    }
    private fun clearToken() {
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        val sharedPrefs = EncryptedSharedPreferences.create(
            context,
            "auth_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        sharedPrefs.edit().remove("auth_token").apply()
    }
}