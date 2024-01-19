package kr.co.greendote.dynamic_library_path_test

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.DataOutputStream
import java.io.IOException
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "kr.co.greendote/android_command"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "runSuCommand") {
                val command = call.argument<String>("command")
                val output = runSuCommand(command)
                result.success(output)
            } else if (call.method == "runSttyCommand") {

                Log.d("MethodChannel", "Method argument: ${call.arguments}")

                val portName = call.argument<String>("portName") ?: "test"
                val baudrate = call.argument<Int>("baudrate") ?: 19200

                Log.d("MethodChannel", "Method called: ${call.method}, Port: $portName, Baudrate: $baudrate")
                runSttyCommand(portName, baudrate)
                result.success(null)
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
            outputStream.writeBytes("$command\nexit\n")
            Log.d("runSuCommand", "command: $command")
            outputStream.flush()

            // 프로세스의 표준 출력 읽기
            val inputStream = process.inputStream
            val reader = BufferedReader(InputStreamReader(inputStream))
            val output = reader.readText()

            process.waitFor()
            return output
        } catch (e: Exception) {
            // 오류 처리
            e.printStackTrace()
            return "Error running command"
        } finally {
            process?.destroy()
        }
    }

    private fun runSttyCommand(portName: String, baudrate: Int) {
        try {
            // val command = "stty -F $portName speed $baudrate cs8 -cstopb -parenb"
            val command = "stty -F $portName speed $baudrate"
            Log.d("runSttyCommand", "command: $command")
            Runtime.getRuntime().exec(command)
        } catch (e: IOException) {
            e.printStackTrace()
            Log.d("runSttyCommand", "Error running command: $e")
        }
    }

}
