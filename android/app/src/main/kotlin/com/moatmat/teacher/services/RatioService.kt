package com.moatmat.teacher.services

import org.opencv.core.Mat
import org.opencv.core.MatOfPoint

class RatioService {

    public  fun getIdRatio(paperType:Int):Double{
        //
        var  ratio = 0.0;
        //
        when (paperType) {
            4 -> { ratio = 0.28 }
            5 -> { ratio = 0.38 }
            6 -> { ratio = 0.55 }
        }
        return ratio
    }

}