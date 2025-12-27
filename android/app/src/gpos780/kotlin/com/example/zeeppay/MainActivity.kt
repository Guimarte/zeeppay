package com.example.zeeppay

import android.graphics.BitmapFactory
import android.graphics.Paint
import android.os.Bundle
import android.view.View
import br.com.gertec.gedi.GEDI
import br.com.gertec.gedi.enums.GEDI_PRNTR_e_Alignment
import br.com.gertec.gedi.exceptions.GediException
import br.com.gertec.gedi.interfaces.IGEDI
import br.com.gertec.gedi.interfaces.IPRNTR
import br.com.gertec.gedi.structs.GEDI_PRNTR_st_PictureConfig
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
                    val header = call.argument<String>("header")
                    val middle = call.argument<String>("middle")
                    val footer = call.argument<String>("footer")
                    val storeInfo = call.argument<String>("storeInfo")
                    val logo = call.argument<ByteArray>("logo")



                    if (header != null && middle != null && footer != null && storeInfo != null && logo != null) {
                        val success = printReceive(header, middle, footer, storeInfo, logo)
                        result.success(success)
                    } else {
                        result.error("PRINT_ERROR", "Erro ao imprimir", null)
                    }
                }

                "printProfile" -> {
                    val content = call.argument<String>("content")

                    if (content != null) {
                        try {
                            val success = printProfile(content)
                            result.success(success)
                        } catch (e: Exception) {
                            result.error("PRINT_ERROR", e.message ?: "Erro desconhecido ao imprimir", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "One or more parameters are null", null)
                    }
                }

                "readCard" -> {
                    transactCard { cardData ->
                        if (cardData != null) {
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

                "stopReadCard" -> {
                    try {
                        val ppComp = PPComp.getInstance(this)
                        ppComp.PP_Abort()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("STOP_ERROR", "Erro ao parar leitura", null)
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
            val timeout = 15_000
            var isDone = false
            try {
                ppComp.PP_StartGetCard(gcr_input)
                val startTime = System.currentTimeMillis()
                while (!isDone) {
                    val elapsed = System.currentTimeMillis() - startTime
                    if (elapsed > timeout) {
                        try {
                            ppComp.PP_Abort()
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                        runOnUiThread { onResult(null) }
                        return@Thread
                    }
                    try {
                        output = ppComp.PP_GetCard()
                        isDone = true
                    } catch (e: PPCompProcessingException) {
                        Thread.sleep(100)
                    } catch (e: PPCompNotifyException) {
                        // Ignora
                    } catch (e: PPCompTabExpException) {
                        try {
                            ppComp.PP_ResumeGetCard()
                        } catch (e2: Exception) {
                            e2.printStackTrace()
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                        runOnUiThread { onResult(null) }
                        return@Thread
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
                runOnUiThread { onResult(null) }
                return@Thread
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

    private fun printReceive(
        header: String,
        middle: String,
        footer: String,
        storeInfo: String,
        logo: ByteArray
    ): Boolean {
        return try {
            val mCL = iGedi!!.cl
            mCL.PowerOff()
            iprntr = iGedi!!.prntr
            iprntr?.let { printer ->


                val logoConfig = GEDI_PRNTR_st_PictureConfig()
                logoConfig.alignment = GEDI_PRNTR_e_Alignment.CENTER
                logoConfig.height = 60
                logoConfig.width = 150
                val bitmap = BitmapFactory.decodeByteArray(logo, 0, logo.size)
                printer.DrawPictureExt(logoConfig, bitmap)
                printer.DrawBlankLine(2) // Espaço antes do header


                // Config para header (negrito)
                val headerConfig = GEDI_PRNTR_st_StringConfig(Paint())
                headerConfig.paint.textAlign = Paint.Align.CENTER
                headerConfig.paint.textSize = 10.0F
                headerConfig.paint.isFakeBoldText = true // negrito
                headerConfig.lineSpace = 4

                val storeInfoConfig = GEDI_PRNTR_st_StringConfig(Paint())
                storeInfoConfig.paint.textAlign = Paint.Align.LEFT
                storeInfoConfig.paint.textSize = 14.0F
                storeInfoConfig.paint.isFakeBoldText = true
                storeInfoConfig.lineSpace = 6

                // Config para body (normal)
                val bodyConfig = GEDI_PRNTR_st_StringConfig(Paint())
                bodyConfig.paint.textAlign = Paint.Align.LEFT
                bodyConfig.paint.textSize = 14.0F
                bodyConfig.paint.isFakeBoldText = false // normal
                bodyConfig.lineSpace = 4

                val footerConfig = GEDI_PRNTR_st_StringConfig(Paint())
                footerConfig.paint.textAlign = Paint.Align.CENTER
                footerConfig.paint.textSize = 14.0F
                footerConfig.paint.isFakeBoldText = false // normal
                footerConfig.lineSpace = 2

                val printBlock: (GEDI_PRNTR_st_StringConfig, String) -> Unit = { config, block ->
                    printer.DrawStringExt(config, block.trim())
                }

                printBlock(headerConfig, header)
                printBlock(storeInfoConfig, storeInfo) // header negrito
                printBlock(bodyConfig, middle)   // middle normal
                printBlock(footerConfig, footer)
                printer.DrawBlankLine(20)
                printer.Output()
            }
            true
        } catch (e: GediException) {
            e.printStackTrace()
            false
        }
    }

    private fun printProfile(content: String): Boolean {
        return try {
            val mCL = iGedi!!.cl
            mCL.PowerOff()
            iprntr = iGedi!!.prntr
            iprntr?.let { printer ->
                try {
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
                } catch (e: GediException) {
                    // Verificar código de erro específico
                    when {
                        e.message?.contains("OUT_OF_PAPER") == true ||
                        e.message?.contains("138") == true -> {
                            throw Exception("Impressora sem papel ou tampa aberta")
                        }
                        else -> {
                            throw Exception("Erro na impressora: ${e.message}")
                        }
                    }
                }
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            throw e
        }
    }

}
