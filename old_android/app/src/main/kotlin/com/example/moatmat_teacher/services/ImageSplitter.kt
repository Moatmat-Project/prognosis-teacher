package com.example.moatmat_teacher.services

import android.util.Log
import io.flutter.plugin.common.MethodChannel
import org.opencv.core.Mat
import org.opencv.core.Rect
import org.opencv.imgproc.Imgproc

class ImageSplitter {
    fun splitImage(image: ByteArray, columns: Int, rows: Int): List<List<Map<String, Any>>> {
        val srcMat = MatService().fromBytes(image)
        // Calculate the dimensions of each part
        val partWidth:Double = srcMat.width() / columns.toDouble()
        val partHeight:Double = srcMat.height() / rows.toDouble()

        val imagesGrid = mutableListOf<List<Map<String, Any>>>()
        // Split the Mat
        for (i in 0 until rows) {
            val rowList = mutableListOf<Map<String, Any>>()
            for (j in 0 until columns) {
                val x = j * partWidth
                val y = i * partHeight
                val width = if (j == columns - 1) srcMat.width() - x else partWidth
                val height = if (i == rows - 1) srcMat.height() - y else partHeight
                val rect = Rect(x.toInt(), y.toInt(), width.toInt(), height.toInt())

                val mat = Mat(srcMat, rect)

                rowList.add(
                    mapOf(
                        "image" to MatService().toBytes(mat),
                        "count" to MatService().countNonZero((mat))
                    )
                )
            }
            imagesGrid.add(rowList)
        }
        return imagesGrid
    }

}