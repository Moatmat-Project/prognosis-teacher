package com.example.moatmat_teacher.services

import android.util.Log
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint
import org.opencv.core.MatOfPoint2f
import org.opencv.core.Point
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc
import kotlin.math.absoluteValue

class ContoursService {

    public  fun  processContours(contours: List<MatOfPoint>,image:Mat,paperType:Int):Int{
        try {
            //
            val id=getIdContour(contours,image,paperType)
            var answers=getAnswersContours(contours,image,paperType)
            var form=getFormContour(contours,image,paperType)
            //
            return answers.size + 2
        }catch (e:Exception){
            return  0
        }

    }

    public  fun getIdContour(contours: List<MatOfPoint>,mat: Mat,paperType: Int): MatOfPoint {
         //
        Log.d("NativeBridge", "log : start searching id")
          //
          var filteredContours: MutableList<MatOfPoint> = mutableListOf()
          //
          filteredContours = ContoursFilter().filterID(contours,mat,paperType).toMutableList()
          //
          if (filteredContours.isEmpty()) {
              throw NoSuchElementException("log : No contour found with the required aspect ratio")
          }
        //
          return filteredContours.first()
      }
    public  fun getFormContour(contours: List<MatOfPoint>,mat: Mat,paperType: Int): MatOfPoint {
        //
        Log.d("NativeBridge", "log : start searching form")
        //
        var filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        filteredContours = ContoursFilter().filterForm(contours,mat,paperType).toMutableList()
        //
        if (filteredContours.isEmpty()) {
            throw NoSuchElementException("log : No contour found with the required aspect ratio,form")
        }
        //
        return filteredContours.first()
    }

    public fun getAnswersContours(contours: List<MatOfPoint>,image:Mat,paperType:Int): List<MatOfPoint> {
        //
        var filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        when (paperType) {
            4 -> { filteredContours = ContoursFilter().filterA4(contours,image).toMutableList() }
            5 -> { filteredContours = ContoursFilter().filterA5(contours,image).toMutableList() }
            6 -> { filteredContours = ContoursFilter().filterA6(contours,image).toMutableList()  }
        }
        //
        if (filteredContours.isEmpty()) {
            throw NoSuchElementException("No contour found with the required aspect ratio")
        }
        //
        return filteredContours
    }

    public fun finContours(mat: Mat): List<MatOfPoint> {
        //
        val hierarchy = Mat()
        //
        val contours: List<MatOfPoint> = ArrayList()
        Imgproc.findContours(
            mat,
            contours,
            hierarchy,
            Imgproc.RETR_EXTERNAL,
            Imgproc.CHAIN_APPROX_NONE
        )
        //
        val filteredContours = mutableListOf<MatOfPoint>()
        //
        for (contour in contours) {
            //
            val area = Imgproc.contourArea(contour)
            //
            if (area > 5000) {
                // Convert MatOfPoint to MatOfPoint2f
                val curve = MatOfPoint2f(*contour.toArray())
                // Calculate the arc length
                val length = Imgproc.arcLength(curve, true)
                //
                val approxCurve = MatOfPoint2f()
                //
                Imgproc.approxPolyDP(curve, approxCurve, 0.02 * length, true)
                // Get the number of vertices in the approximated contour
                val approxVertices = approxCurve.toArray().size
                // Example: Check if the approximated shape is a rectangle
                if (approxVertices == 4) {
                    filteredContours.add(contour)
                }
            }
        }
        //
        val sortedList: List<MatOfPoint> = filteredContours.sortedBy { matOfPoint ->
            val rect = Imgproc.boundingRect(matOfPoint)
            rect.width
        }
        //
        return removeDuplicated(sortedList.toMutableList())
    }

    private  fun removeDuplicated(list: MutableList<MatOfPoint>): MutableList<MatOfPoint> {
        //
        list.sortBy { MatService().getCenterUsingMoments(it).x }
        //
        var i = 0
        while (i < list.size) {
            if (i > 0) {
                //
                val centerCurrent = MatService().getCenterUsingMoments(list[i])
                val centerPrevious = MatService().getCenterUsingMoments(list[i - 1])
                //
                val con1 = centerCurrent.x == centerPrevious.x
                val con2 = (centerCurrent.x - centerPrevious.x).absoluteValue < 100
                val con3 = centerCurrent.y == centerPrevious.y
                val con4 = (centerCurrent.y - centerPrevious.y).absoluteValue < 100
                //
                if ((con1 || con2) && (con3 || con4)) {
                    list.removeAt(i)
                    i--
                }
            }
            i++
        }
        return list
    }


}
