package com.example.zeeppay


import android.graphics.Paint
import android.os.Bundle
import android.view.View
import br.com.gertec.gedi.GEDI
import br.com.gertec.gedi.exceptions.GediException
import br.com.gertec.gedi.interfaces.IGEDI
import br.com.gertec.gedi.interfaces.IPRNTR
import br.com.gertec.gedi.structs.GEDI_PRNTR_st_StringConfig
import br.com.gertec.gpos780.ppcomp.PPComp
import br.com.gertec.gpos780.ppcomp.exceptions.PPCompNotifyException
import br.com.gertec.gpos780.ppcomp.exceptions.PPCompProcessingException
import br.com.gertec.gpos780.ppcomp.exceptions.PPCompTabExpException

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var iGedi: IGEDI? = null
    private var iprntr: IPRNTR? = null
    private val CHANNEL = "com.example.zeeppay/printer"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GEDI.init(this)
        Thread {
            iGedi = GEDI.getInstance(this@MainActivity)
        }.start()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "printReceive" -> {
                    val success = printReceive()
                    if (success) {
                        result.success(null)
                    } else {
                        result.error("PRINT_ERROR", "Erro ao imprimir", null)
                    }
                }

                "readCard" -> {
                    transactCard { cardData ->
                        if (cardData != null) {
                            result.success(cardData)
                        } else {
                            result.error("CARD_ERROR", "Erro ao ler cartão", null)

                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    fun transactCard(onResult: (String?) -> Unit) {
        Thread {
            val ppComp = PPComp.getInstance(this)
            val gcr_input = "0001000000001000691231210457012345678900"
            var output: String? = null
            try {
                ppComp.PP_StartGetCard(gcr_input)
                while (true) {
                    try {
                        output = ppComp.PP_GetCard()
                        break
                    } catch (e: PPCompProcessingException) {
                        // Aguarda e tenta novamente
                        Thread.sleep(100)
                    } catch (e: PPCompNotifyException) {
                        // Ignora e tenta novamente
                    } catch (e: PPCompTabExpException) {
                        ppComp.PP_ResumeGetCard()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            // Volta para a thread UI para chamar o callback com o resultado
            runOnUiThread {
                onResult(output)
            }
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
