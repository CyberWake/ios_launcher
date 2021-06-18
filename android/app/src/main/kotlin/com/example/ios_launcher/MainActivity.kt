package com.example.ios_launcher

import android.annotation.SuppressLint
import android.content.pm.ApplicationInfo
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val channel = "com.cyberwake.ioslauncher/platformData"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->
            if(call.method == "getApps"){
                result.success(getApps())
            }else{
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    @SuppressLint("QueryPermissionsNeeded")
    private fun getApps(): List<Map<String,Any>> {
        val res: MutableList<Map<String,Any>> = mutableListOf()
        val packs = packageManager.getInstalledApplications(0)
        for (i in packs.indices) {
            val p = packs[i]
            if(packageManager.getLaunchIntentForPackage(p.packageName) != null){
                val appName = packageManager.getApplicationLabel(p).toString()
                val appPackage = p.packageName
                val appIcon = packageManager.getApplicationIcon(p).toString()
                val category = "Undefined"
                res.add(mapOf("appName" to appName,"package" to appPackage,"icon" to appIcon,"category" to category))
            }
        }
        return res
    }
}
