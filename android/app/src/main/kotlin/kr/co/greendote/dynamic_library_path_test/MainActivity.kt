package kr.co.greendote.dynamic_library_path_test

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.DataOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "kr.co.greendote/su"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "runSuCommand") {
                val command = call.argument<String>("command")
                val output = runSuCommand(command)
                result.success(output)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun runSuCommand(command: String?): String {
        var process: Process? = null
        try {
            process = Runtime.getRuntime().exec("su")
            val outputStream = DataOutputStream(process.outputStream)
            outputStream.writeBytes("$command\n")
            outputStream.writeBytes("exit\n")
            outputStream.flush()
            process.waitFor()
            return outputStream.toString()
        } catch (e: Exception) {
            // 오류 처리
            e.printStackTrace()
            return "Error running command"
        }
    }
}
