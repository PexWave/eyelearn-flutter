package com.example.learnhear

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import edu.cmu.pocketsphinx.Assets
import edu.cmu.pocketsphinx.Hypothesis
import edu.cmu.pocketsphinx.RecognitionListener
import edu.cmu.pocketsphinx.SpeechRecognizer
import edu.cmu.pocketsphinx.SpeechRecognizerSetup
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.IOException


//class MainActivity: FlutterActivity() {}

class MainActivity: FlutterActivity(), RecognitionListener {
    private val SPEEC_ROGNITION_CHANNEL = "com.learnhear/speechrecognition"
    private lateinit var channel: MethodChannel
    private val job = Job()
    private val coroutineScope = CoroutineScope(Dispatchers.Main + job)
    private val PERMISSIONS_REQUEST_RECORD_AUDIO = 1
    /* We only need the keyphrase to start recognition, one menu with list of choices,
       and one word that is required for method switchSearch - it will bring recognizer
       back to listening for the keyphrase*/
    private val KWS_SEARCH = "wakeup"
    private val MENU_SEARCH = "menu"

    /* Keyword we are looking for to activate recognition */
    private val KEYPHRASE = "hello maya"

    /* Recognition object */
    private var recognizer: SpeechRecognizer? = null



    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,SPEEC_ROGNITION_CHANNEL)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "stopPocketPhinx" -> {
                    val data = call.arguments
                    // Handle the data and perform your function.
                    stopPocketPhinx()
                    // You can send a response back to Flutter if needed.
                    result.success("Response from native")
                }

                "resetPocketPhinx" -> {
                    val data = call.arguments
                    // Handle the data and perform your function.
                    reset()
                    // You can send a response back to Flutter if needed.
                    result.success("Response from native")
                }
                else -> result.notImplemented()
            }
        }
    }


    override fun onCreate(state: Bundle?) {
        super.onCreate(state)

        // Check if user has given permission to record audio
        // Check if user has given permission to record audio
        val permissionCheck = ContextCompat.checkSelfPermission(
            applicationContext, Manifest.permission.RECORD_AUDIO
        )
        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf<String>(Manifest.permission.RECORD_AUDIO),
                PERMISSIONS_REQUEST_RECORD_AUDIO
            )
            return
        }

        coroutineScope.launch {
            runRecognizerSetup()
        }


    }


    private fun runRecognizerSetup() {
        GlobalScope.launch(Dispatchers.Main) {
            val result = withContext(Dispatchers.IO) {
                try {
                    val assets = Assets(this@MainActivity)
                    val assetDir: File = assets.syncAssets()
                    setupRecognizer(assetDir)
                    null
                } catch (e: IOException) {
                    e
                }
            }

            result?.let {
                println(it.message)
            } ?: run {
//                reset()
            }
        }
    }


    private fun setupRecognizer(assetsDir: File) {
        recognizer = SpeechRecognizerSetup.defaultSetup()
            .setAcousticModel(File(assetsDir, "en-us-ptm"))
            .setDictionary(File(assetsDir, "cmudict-en-us.dict"))
            // Disable this line if you don't want the recognizer to save raw
            // audio files to the app's storage
            //.setRawLogDir(assetsDir)
            .setKeywordThreshold(1.0E-20F)
            .recognizer

        recognizer?.addListener(this)

        // Create keyword-activation search.
        recognizer?.addKeyphraseSearch(KWS_SEARCH, KEYPHRASE)

        // Create your custom grammar-based search
        val menuGrammar = File(assetsDir, "mymenu.gram")
//        recognizer?.addKeywordSearch(MENU_SEARCH, menuGrammar)


    }

// Assuming recognizer, KWS_SEARCH, KEYPHRASE, and MENU_SEARCH properties/fields are defined elsewhere in your code



    override fun onStop() {
        super.onStop()
        coroutineScope.launch {
            withContext(Dispatchers.IO) {
                recognizer?.apply {
                    cancel()
                    shutdown()
                }
            }
        }
    }

    private fun switchSearch(searchName: String) {
        recognizer?.stop()
        if (searchName == KWS_SEARCH) recognizer?.startListening(searchName) else recognizer?.startListening(
            searchName,
            10000
        )
    }

    override fun onPartialResult(hypothesis: Hypothesis?) {


    }

    private fun reset() {
        recognizer?.stop()
        recognizer?.startListening(KWS_SEARCH)
    }


    private fun stopPocketPhinx() {
        recognizer?.stop()
    }


    override fun onResult(hypothesis: Hypothesis?) {
        if (hypothesis != null) {
            println(hypothesis.hypstr)

        if (hypothesis.hypstr == KEYPHRASE)
            {
                channel.invokeMethod("methodNameInFlutter", "Some data or null")
                print("activating")
//                recognizer?.stop()
            }
        }
    }



    override fun onBeginningOfSpeech() {
        // Your implementation here, if needed
    }


    override fun onEndOfSpeech() {
        reset()
    }


    override fun onError(error: Exception) {
        println(error.message)
    }

    override fun onTimeout() {

    }


    override fun onDestroy() {
        super.onDestroy()

        job.cancel() // Cancel the coroutine job when the activity is destroyed
    }



}

