package com.example.zeeppay


import android.R
import android.app.ProgressDialog
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.webkit.WebSettings.TextSize
import br.com.gertec.gedi.GEDI
import br.com.gertec.gedi.exceptions.GediException
import br.com.gertec.gedi.interfaces.IGEDI
import br.com.gertec.gedi.interfaces.IPRNTR
import br.com.gertec.gedi.structs.GEDI_PRNTR_st_StringConfig
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity(){
    var iGedi: IGEDI? = null
    var iprntr: IPRNTR? = null
    private val CHANNEL = "com.example.zeeppay/printer"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "printReceive") {
                val success = printReceive()
                if (success) {
                    result.success(null)
                } else {
                    result.error("PRINT_ERROR", "Erro ao imprimir", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GEDI.init(this)
        Thread {
            iGedi = GEDI.getInstance(this@MainActivity)
        }.start()
    }


    private fun printReceive(): Boolean {
        return try {
            val mCL = iGedi!!.cl
            mCL.PowerOff()
            iprntr = iGedi!!.prntr
            iprntr?.let { printer ->
                printer.Init()
                val strconfig = GEDI_PRNTR_st_StringConfig(Paint())
                strconfig.paint.textAlign = Paint.Align.CENTER
                strconfig.paint.textSize = 48.0F
                strconfig.paint.isFakeBoldText = true                 
                strconfig.offset = 0
                strconfig.lineSpace = 0
                printer.DrawStringExt(strconfig, "Teste de impressão via Flutter")
                printer.DrawBlankLine(20)
                printer.Output()
            }
            true
        } catch (e: GediException) {
            e.printStackTrace()
            false
        }
    }
}
