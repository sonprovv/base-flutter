package com.example.flutter_app_factory_base

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.flutter_app_factory_base/shortcut_uninstall"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialRoute" -> {
                        val route = extractRoute(intent)
                        result.success(route)
                    }
                    "createUninstallShortcut" -> {
                        val success = createUninstallShortcut()
                        result.success(success)
                    }
                    "uninstallApp", "openAppSettings" -> {
                        val success = openAppSettings()
                        result.success(success)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val route = extractRoute(intent)
        if (route != null) {
            methodChannel?.invokeMethod("onShortcutRoute", route)
        }
    }

    private fun extractRoute(intent: Intent?): String? {
        if (intent == null) return null
        if (intent.hasExtra("route")) {
            return intent.getStringExtra("route")
        }
        if (intent.action == "com.example.flutter_app_factory_base.UNINSTALL") {
            return "/uninstall"
        }
        val dataStr = intent.dataString
        if (dataStr != null && dataStr.contains("/uninstall")) {
            return "/uninstall"
        }
        return null
    }

    private fun createUninstallShortcut(): Boolean {
        return try {
            val shortcutIntent = Intent(context, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                putExtra("route", "/uninstall")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }

            val shortcut = ShortcutInfoCompat.Builder(context, "shortcut_uninstall")
                .setIcon(IconCompat.createWithResource(context, R.drawable.ic_shortcut_uninstall))
                .setShortLabel(getString(R.string.shortcut_uninstall_label))
                .setLongLabel(getString(R.string.shortcut_uninstall_long_label))
                .setIntent(shortcutIntent)
                .build()

            // Push dynamic shortcut to launcher menu
            ShortcutManagerCompat.pushDynamicShortcut(context, shortcut)

            // Pin to home screen if supported
            if (ShortcutManagerCompat.isRequestPinShortcutSupported(context)) {
                ShortcutManagerCompat.requestPinShortcut(context, shortcut, null)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun openAppSettings(): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:$packageName")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
            true
        } catch (e: Exception) {
            try {
                val fallbackIntent = Intent(Settings.ACTION_SETTINGS).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                startActivity(fallbackIntent)
                true
            } catch (ex: Exception) {
                ex.printStackTrace()
                false
            }
        }
    }
}
