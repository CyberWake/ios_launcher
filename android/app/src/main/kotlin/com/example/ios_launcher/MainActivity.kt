package com.example.ios_launcher

import android.annotation.SuppressLint
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Build.VERSION_CODES.N_MR1
import android.provider.MediaStore
import android.provider.Telephony
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream


class MainActivity: FlutterActivity() {
    private val channel = "com.cyberwake.ioslauncher/platformData"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "getApps" -> {
                    result.success(getApps())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @SuppressLint("QueryPermissionsNeeded")
    private fun getApps(): List<Map<String,Any>> {
        val res: MutableList<Map<String,Any>> = mutableListOf()
        if(SDK_INT >= Build.VERSION_CODES.KITKAT && SDK_INT >= Build.VERSION_CODES.O){
            var mainIntent = Intent(Intent.ACTION_DIAL, null)
            mainIntent.addCategory(Intent.CATEGORY_DEFAULT)
            var pkgAppsList = packageManager.queryIntentActivities(mainIntent, 0)
            val info0 = pkgAppsList[0].activityInfo.applicationInfo
            res.add(mapOf("appName" to info0.loadLabel(packageManager),"package" to info0.packageName,"icon" to drawableToByteArray(info0.loadIcon(packageManager)),"category" to "Tray Apps"))
            Log.i("info0",res[0].toString())

            mainIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            pkgAppsList =
                packageManager.queryIntentActivities(mainIntent, PackageManager.MATCH_DEFAULT_ONLY)
            val info1 = pkgAppsList[0].activityInfo.applicationInfo
            res.add(mapOf("appName" to info1.loadLabel(packageManager),"package" to info1.packageName,"icon" to drawableToByteArray(info1.loadIcon(packageManager)),"category" to "Tray Apps"))
            Log.i("info1",res[1].toString())

            val smsPkgName = Telephony.Sms.getDefaultSmsPackage(context)
            val info2 = packageManager.getApplicationInfo(smsPkgName, 0)
            res.add(mapOf("appName" to info2.loadLabel(packageManager),"package" to info2.packageName,"icon" to drawableToByteArray(info2.loadIcon(packageManager)),"category" to "Tray Apps"))
            Log.i("info2",res[2].toString())

            val browserIntent = Intent(Intent.ACTION_VIEW, Uri.parse("http://"))
            val resolveInfo = packageManager.resolveActivity(
                browserIntent,
                PackageManager.MATCH_DEFAULT_ONLY
            )
            val info3 = resolveInfo!!.activityInfo.applicationInfo
            res.add(mapOf("appName" to info3.loadLabel(packageManager),"package" to info3.packageName,"icon" to drawableToByteArray(info3.loadIcon(packageManager)),"category" to "Tray Apps"))
            Log.i("info3",res[3].toString())
            val packs = packageManager.getInstalledApplications(0)
            for (i in packs.indices) {
                val p = packs[i]
                if(packageManager.getLaunchIntentForPackage(p.packageName) != null){
                    val appName = packageManager.getApplicationLabel(p).toString()
                    val appPackage = p.packageName
                    val appIcon = drawableToByteArray(p.loadIcon(packageManager))
                    val category = "Undefined"
                    if(appPackage!=info0.packageName && appPackage!=info1.packageName && appPackage!=info2.packageName && appPackage!=info3.packageName) {
                        res.add(
                            mapOf(
                                "appName" to appName,
                                "package" to appPackage,
                                "icon" to appIcon,
                                "category" to category
                            )
                        )
                    }
                    Log.i("app",res.last().toString())
                }
            }
        }
        return res
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = drawableToBitmap(drawable)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        if (SDK_INT <= N_MR1) return (drawable as BitmapDrawable).bitmap
        val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }
}
