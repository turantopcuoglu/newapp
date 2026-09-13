package com.example.ai_recipe_app

import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    private fun isHealthPrivacyIntent(intent: Intent?): Boolean =
        intent?.action == "androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" ||
        intent?.action == "android.intent.action.VIEW_PERMISSION_USAGE"

    override fun getInitialRoute(): String? =
        if (isHealthPrivacyIntent(intent)) "/health-privacy" else super.getInitialRoute()

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (isHealthPrivacyIntent(intent)) {
            flutterEngine?.navigationChannel?.pushRoute("/health-privacy")
        }
    }
}
