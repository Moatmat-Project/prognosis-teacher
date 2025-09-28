package com.prognosis.teacher

import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import com.prognosis.teacher.resources.YuvConverter
import com.prognosis.teacher.services.ContoursService
import com.prognosis.teacher.services.ImageSplitter
import com.prognosis.teacher.services.MatService
import com.prognosis.teacher.services.WrapperService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import org.opencv.android.OpenCVLoader
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint

class MainActivity : FlutterActivity() {
    private val channel = "com.prognosis.teacher"
    private var job: Job? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //
        OpenCVLoader.initLocal()
        //
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "process_image" -> {
                    processImage(call.arguments, result)
                }
                "extract_images"->{
                    // pars data
                    val data = call.arguments as Map<*, *>
                    // get image
                    val bytesList = data["image"] as ByteArray
                    //
                    val type = data["type"] as Int
                    //
                    val bytes=extractImages(bytesList,type)
                    //
                    result.success(bytes)
                }
                "analyze_image"->{
                    val data = call.arguments as Map<String, Any>
                    val image = data["image"] as ByteArray
                    val columns= data["columns"] as Int
                    val rows=data["rows"] as Int
                    val images =  ImageSplitter().splitImage(image,columns,rows)
                    result.success(images)
                }
                else -> result.notImplemented()
            }
        }
    }


    private  fun  extractImages(bytes: ByteArray,type:Int):List<ByteArray>{
        //
        val images: MutableList<ByteArray> = mutableListOf()
        //
        val mat = MatService().fromBytes(bytes)
        //
        val praperd =  MatService().praperImage(mat)
        //
        val contours=ContoursService().finContours(praperd)
        //
        images.addAll(getIDImage(mat,contours,type))
        //
        images.addAll(getAnswersImages(mat,contours,type))
        //
        images.addAll(getFormImage(mat,contours,type))
        //
        Log.e("testing", "log : images length is ${images.size}")
        //
        return images
    }
    private fun getIDImage(mat:Mat, contours:List<MatOfPoint>,paperType:Int):List<ByteArray>{
        return try {
            val idContour = ContoursService().getIdContour(contours,mat, paperType )
            var wrapped=WrapperService().warpImageBasedOnPoints(mat,idContour)
            //
            Log.d("NativeBridge", "log : done getting id")
            listOf<ByteArray>(MatService().toBytes(wrapped))
        } catch (e:Exception){
            Log.d("NativeBridge", "log : error while getting id, $e")
            listOf<ByteArray>()
        }
    }
    private fun getFormImage(mat:Mat, contours:List<MatOfPoint>,paperType:Int):List<ByteArray>{
        return try {
            val formContour = ContoursService().getFormContour(contours,mat, paperType )
            var wrapped=WrapperService().warpImageBasedOnPoints(mat,formContour)
            //
            Log.d("NativeBridge", "log : done getting form")
            listOf<ByteArray>(MatService().toBytes(wrapped))
        } catch (e:Exception){
            Log.d("NativeBridge", "log : error while getting form, $e")
            listOf<ByteArray>()
        }
    }
    private fun getAnswersImages(mat:Mat, contours:List<MatOfPoint>,type:Int):List<ByteArray>{
        return try {
            //
            val images: MutableList<ByteArray> = mutableListOf()
            // getting answers contours
            val answersContour = ContoursService().getAnswersContours(contours,mat,type)
            // processing answers contours
            for(c in answersContour){
            var wrapped=WrapperService().warpImageBasedOnPoints(srcImage = mat, contour = c)
                images.add(MatService().toBytes(wrapped))
            }
            // return images
            images
        } catch (e:Exception){
            Log.d("NativeBridge", "log : error while getting answers, $e")
            listOf<ByteArray>();
        }
    }
    private fun processImage(data: Any, result: MethodChannel.Result) {
        if (job?.isActive == false || job == null) {
            job = CoroutineScope(Dispatchers.Main).launch {
                val imageBytes = withContext(Dispatchers.Default) {
                    val key = data as Map<String, Any>
                    val bytesList = key["platforms"] as List<ByteArray>
                    val strides = key["strides"] as IntArray
                    val width = key["width"] as Int
                    val height = key["height"] as Int
                    YuvConverter.NV21toJPEG(YuvConverter.YUVtoNV21(bytesList, strides, width, height), width, height, 100)
                }
                //
                val decodedImage = withContext(Dispatchers.Default) {
                    BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                }
                //
                withContext(Dispatchers.Default) {
                    //
                    val key = data as Map<String, Any>
                    //
                    val type = key["type"] as Int
                    //
                    val list= mutableListOf<MatOfPoint>()
                    //
                    val mat = MatService().fromBytes(imageBytes)
                    //
                    val praperd =  MatService().praperImage(mat)
                    //
                    val contours=ContoursService().finContours(praperd)
                    //
                    val counter=ContoursService().processContours(contours,mat,type)
                    //
                    try {result.success(counter)}catch (e:Exception){result.success(0)}
                }
            }
        }
    }
}




