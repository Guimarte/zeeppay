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

    private var sPanFromLastTrack: String = ""

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

                "printProfile" -> {
                    val content = call.argument<String>("content")
                    if (content != null) {
                        val success = printReceive(content)
                        result.success(success)
                    } else {
                        result.error("INVALID", "Content is null", null)
                    }
                }

                "readCard" -> {
                    transactCard { cardData ->
                        if (cardData != null) {
                            // Tenta extrair o PAN a partir das trilhas 1, 2 ou 3
                            try {
                                val pan = when {
                                    cardData.contains("^") -> getPan(cardData, 1)
                                    cardData.contains("=") -> getPan(cardData, 2)
                                    else -> getPan(cardData, 3)
                                }
                                result.success(pan)
                            } catch (e: Exception) {
                                result.error("PAN_ERROR", "Erro ao extrair PAN", null)
                            }
                        } else {
                            result.error("CARD_ERROR", "Erro ao ler cartão", null)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun transactCard(onResult: (String?) -> Unit) {
        Thread {
            val ppComp = PPComp.getInstance(this)
            val gcr_input = "0001000000001000691231210457012345678900"
            var output: String? = null
            val startTime = System.currentTimeMillis()
            val timeout = 15_000

            try {
                ppComp.PP_StartGetCard(gcr_input)

                while (true) {
                    if (System.currentTimeMillis() - startTime > timeout) {
                        println("System.currentTimeMillis() - startTime > timeout = ${System.currentTimeMillis() - startTime > timeout}")
                        ppComp.PP_Close("")
                        runOnUiThread {
                            onResult(null)
                        }
                        return@Thread
                    }

                    try {
                        output = ppComp.PP_GetCard()
                        break
                    } catch (e: PPCompProcessingException) {
                        Thread.sleep(100)
                    } catch (e: PPCompNotifyException) {
                        // Ignora
                    } catch (e: PPCompTabExpException) {
                        ppComp.PP_ResumeGetCard()
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            runOnUiThread {
                onResult(output)
            }
        }.start()
    }


    private fun getPan(sTrack: String, iTrackNumber: Int): String {
        var iIndexOfInit = 0
        var iIndexOfDelimiter = 0
        if (iTrackNumber == 1 && '^' in sTrack) {
            iIndexOfInit = 1
            iIndexOfDelimiter = sTrack.indexOf('^')
        } else if (iTrackNumber == 2 && '=' in sTrack) {
            iIndexOfInit = 0
            iIndexOfDelimiter = sTrack.indexOf('=')
        } else if (iTrackNumber == 3 && sPanFromLastTrack.isNotEmpty()) {
            return sPanFromLastTrack
        } else {
            throw Exception("RET_MCDATAERR")
        }
        sPanFromLastTrack = sTrack.substring(iIndexOfInit, iIndexOfDelimiter)
        return sPanFromLastTrack
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

    private fun printReceive(content: String): Boolean {
        return try {
            val mCL = iGedi!!.cl
            mCL.PowerOff()

            iprntr = iGedi!!.prntr
            iprntr?.let { printer ->
                printer.Init()

                val strconfig = GEDI_PRNTR_st_StringConfig(Paint())
                strconfig.paint.textAlign = Paint.Align.LEFT
                strconfig.paint.textSize = 24.0F
                strconfig.paint.isFakeBoldText = false
                strconfig.offset = 0
                strconfig.lineSpace = 5

                val lines = content.split("\n")
                for (line in lines) {
                    printer.DrawStringExt(strconfig, line.trim())
                }

                printer.DrawBlankLine(10)
                printer.Output()
            }
            true
        } catch (e: GediException) {
            e.printStackTrace()
            false
        }
    }
}
