package com.moatmat.teacher.services

import org.opencv.core.Mat
import org.opencv.core.Point
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc

class CircleDetector {


    fun detectCircles(mat: Mat): Mat {
        // Convert to grayscale
        val prapered = MatService().praperImage(mat);

        // Detect circles using HoughCircles
        val circles = Mat()
        Imgproc.HoughCircles(
            prapered,
            circles,
            Imgproc.HOUGH_GRADIENT,
            1.0,
            1.0,
            300.0, // Higher thresshold for Canny edge detector
            30.0, // Accumulator threshold for center detection
           1,    // Minimum radius
           mat.height()/5,     // Maximum radius
        )

        // Draw the circles on the original image
        if (circles.cols() > 0) {
            for (i in 0 until circles.cols()) {
                val circleVec = circles.get(0, i)
                val center = Point(circleVec[0], circleVec[1])
                val radius = circleVec[2].toInt()
                // Draw the circle outline
                Imgproc.circle(mat, center, radius, Scalar(0.0, 255.0, 0.0), 3)
                // Draw the circle center
                Imgproc.circle(mat, center, 3, Scalar(0.0, 255.0, 0.0), 3)
            }
        }

        return mat
    }

}