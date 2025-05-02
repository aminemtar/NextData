package com.example.android_flutter_test
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine



class MainActivity : FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        AuthHandler(this, flutterEngine)

        DatabaseHandler(this, flutterEngine)
    }
}