package com.example.moatmat_teacher.services

import android.util.Log
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint
import org.opencv.imgproc.Imgproc

class ContoursFilter {
    //
    public fun filterID(contours: List<MatOfPoint>,mat: Mat,paperType:Int):List<MatOfPoint>{
        //
        val filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        for (contour in contours) {
            //
            val contourSize = Imgproc.boundingRect(contour)
            val ratio = contourSize.width.toDouble() / contourSize.height.toDouble()
            //
            val con1=ratio < 1.63
            val con2 = ratio > 1.23
            val con3=contourSize.width<mat.width()/2
            val con4=contourSize.height/mat.height() <RatioService().getIdRatio(paperType)
            //
            if ( con1 &&  con2  && con3 && con4) {
                filteredContours.add(contour)
                Log.d("NativeBridge", "filter id : accept r : $ratio , w:${contourSize.width} W:${mat.width()},h:${contourSize.height} H:${mat.height()}")
            }else if(con1&&con2){
                Log.d("NativeBridge", "filter id : decline r : $ratio , w:${contourSize.width} W:${mat.width()},h:${contourSize.height} H:${mat.height()}")
            }
        }
        //
        val sortedList = filteredContours.sortedByDescending { matOfPoint ->
            MatService().getCenterUsingMoments(matOfPoint).y
        }
        //
        return sortedList
    }
    public fun filterForm(contours: List<MatOfPoint>,mat: Mat,paperType:Int):List<MatOfPoint>{
        //
        val filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        for (contour in contours) {
            //
            val contourSize = Imgproc.boundingRect(contour)
            val ratio = contourSize.width.toDouble() / contourSize.height.toDouble()
            //
            val con1=ratio < 0.32
            val con2 = ratio > 0.18
            val con3=contourSize.width<mat.width()/3
            val con4=contourSize.width< (contourSize.height*2)
            //
            if ( con1 &&  con2  && con3 ) {
                filteredContours.add(contour)
                Log.d("NativeBridge", "filter form : accept r : $ratio , w:${contourSize.width} W:${mat.width()},h:${contourSize.height} H:${mat.height()}")
            }else if(con1&&con2){
                Log.d("NativeBridge", "filter form : decline r : $ratio , w:${contourSize.width} W:${mat.width()},h:${contourSize.height} H:${mat.height()}")
            }
        }
        //
        val sortedList = filteredContours.sortedByDescending { matOfPoint ->
            MatService().getCenterUsingMoments(matOfPoint).y
        }
        //
        return sortedList
    }
    //
    public fun filterA4(contours: List<MatOfPoint>,mat: Mat):List<MatOfPoint>{
        //
        val ratio1 = 4.1
        val range = 0.5
        //
        val filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        for (contour in contours) {
            //
            val contourSize = Imgproc.boundingRect(contour)
            //
            val ratio = contourSize.width.toDouble() / contourSize.height.toDouble()
            //
            val con1 = ratio < ratio1 + range
            val con2 = ratio > ratio1 - range
            val con3 = contourSize.height< ( mat.height() / 4 )
            //
            if ( con1 &&  con2 && con3) {
                filteredContours.add(contour)
                Log.d("NativeBridge", "filter : accept answers a4 ratio : $ratio h:${contourSize.height},H:${mat.height()},1:$con1,2:$con2,3:$con3")

            }else{
                Log.d("NativeBridge", "filter : decline answers a4 ratio : $ratio h:${contourSize.height},H:${mat.height()},1:$con1,2:$con2,3:$con3")

            }

        }
        //
        val sortedList = filteredContours.sortedByDescending { matOfPoint ->
            MatService().getCenterUsingMoments(matOfPoint).y
        }
        //
        return sortedList
    }
    public fun filterA5(contours: List<MatOfPoint>,mat: Mat):List<MatOfPoint>{
        //
        var ratio1 = 2.8
        var ratio2 = 2.6
        val range = 1
        //
        val filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        for (contour in contours) {
            //
            val contourSize = Imgproc.boundingRect(contour)
            val ratio = contourSize.width.toDouble() / contourSize.height.toDouble()
            //
            val con1 = ratio < ratio1 + range
            val con2 = ratio > ratio1 - range
            val con3 = ratio < ratio2 + range
            val con4 = ratio > ratio2 - range
            val con5 = contourSize.height< ( mat.height() / 3 )
            //
            if ( (con1 &&  con2 || con3 && con4)&& con5) {
                filteredContours.add(contour)
            }else{
                Log.d("NativeBridge", "log : decline answers ratio : $ratio")
            }
        }
        //
        val sortedList = filteredContours.sortedByDescending { matOfPoint ->
            MatService().getCenterUsingMoments(matOfPoint).y
        }
        //
        return sortedList
    }
    public fun filterA6(contours: List<MatOfPoint>,mat: Mat):List<MatOfPoint>{
        //
        val ratio1 = 2.1
        val ratio2 =  2.8
        val range = 0.2
        //
        val filteredContours: MutableList<MatOfPoint> = mutableListOf()
        //
        for (contour in contours) {
            //
            val contourSize = Imgproc.boundingRect(contour)
            val ratio = contourSize.width.toDouble() / contourSize.height.toDouble()
            //
            val con1 = ratio < ratio1 + range
            val con2 = ratio > ratio1 - range

            val con3 = ratio < ratio2 + range
            val con4 = ratio > ratio2 - range
            //
            val con5 = contourSize.height< ( mat.height() / 2 )
            //
            if ( (con1 &&  con2 || con3 && con4)&& con5) {
                filteredContours.add(contour)
            }else{
                Log.d("NativeBridge", "log : decline answers ratio : $ratio,, h${contourSize.height}, H${mat.height()}")
            }
        }
        //
        val sortedList = filteredContours.sortedByDescending { matOfPoint ->
            MatService().getCenterUsingMoments(matOfPoint).y
        }
        //
        return sortedList
    }
}