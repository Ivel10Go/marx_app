package com.example.marx_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
	}

	override fun onNewIntent(intent: android.content.Intent) {
		super.onNewIntent(intent)
		setIntent(intent)
	}

	override fun getInitialRoute(): String {
		val route = intent?.getStringExtra("launch_route")
		return route?.takeIf { it.isNotBlank() } ?: super.getInitialRoute() ?: "/"
	}
}
